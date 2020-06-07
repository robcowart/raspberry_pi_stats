# Raspberry Pi Statistics

A script to collect various Raspberry Pi statistics, which are sent via Telegraf to InfluxDB.

## Notes about my modifications:
Most of the files have been modified, and the OC settings in config.txt are:
```python
# Overclocking:
over_voltage=6
arm_freq=2000

isp_freq=750
v3d_freq=750
h264_freq=750
hdmi_enable_4kp60=1 # This is the only way to overclock the Core, uping it to 550MHz

sdram_freq=3200
```

![raspberry_pi_stats_github_social](https://user-images.githubusercontent.com/10326954/59145214-fce42300-89e0-11e9-9de4-f5b3e2cd4507.png)

## Collecting Raspberry Pi Statistics

The provided `rpi-stats.sh` script collects statistics using Raspbian's `vcgencmd` command. These values are parsed from the command's output and formatted in InfluxDB's [line protocol](https://docs.influxdata.com/influxdb/v1.7/write_protocols/line_protocol_tutorial/) for easy collection via Telegraf's [exec](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/exec) input.

> To learn how to install Telegraf (and the rest of the TICK Stack) on the Raspberry Pi, refer to this [blog](https://www.influxdata.com/blog/running-the-tick-stack-on-a-raspberry-pi/).

Copy the script to the directory from which you wish to run it (I usually put it in `/usr/local/bin`), and ensure that it can be executed by the user under which Telegraf will be run (the default user is `telegraf`). The user will need to have `sudo` rights.

Configure the Telegraf [exec](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/exec) input to execute the script. For example...

```toml
[[inputs.exec]]
  # Commands array
  commands = [ "/usr/local/bin/rpi-stats.sh" ]
  # Timeout for each command to complete.
  timeout = "5s"
  # Data format to consume.
  data_format = "influx"
```

> A complete Telegraf configuration file (`telegraf.conf`) is provided to help you get started.

After Telegraf is started, data will be sent to InfluxDB.

## Import the Dashboard

A Raspberry Pi Health dashboard for Chronograf is provided in the file `Raspberry_Pi_Health.json`. This can be imported from Chronograf's Dashboards list.

![Raspberry Pi: Health](https://user-images.githubusercontent.com/10326954/59144161-b50acf00-89d3-11e9-8b8e-988b6dc7c730.png)

## Collected Statistics

Metric | Description
--- | ---
arm_freq | clock frequency of the ARM processor
arm_mem | memory size allocated to the ARM processor
core_freq | clock frequency of the SOC
config_arm_freq | configured clock frequency of the ARM processor
config_core_freq | configured clock frequency of the SOC
config_gpu_freq | configured clock frequency of the GPU
config_sdram_freq | configured clock frequency of the SDRAM
core_volts | voltage provided to the SOC
dpi_freq | clock frequency of the DPI
emmc_freq | clock frequency of the EMMC
gpu_mem | memory size allocated to the GPU
h264_freq | clock frequency of the H.264
hdmi_freq | clock frequency of the HDMI
isp_freq | clock frequency of the ISP
malloc_mem | free GPU memory in the malloc heap
malloc_total_mem | total memory assigned to the GPU malloc heap
mem_reloc_allocation_failures | relocatable memory failures
mem_reloc_compactions | relocatable memory compactions
mem_reloc_legacy_block_failures | relocatable memory legacy block failures
oom_count | count of out-of-memory events
oom_ms | total milliseconds in the out-of-memory handler
pixel_freq | clock frequency of the Pixel
pwm_freq | clock frequency of the PWM
reloc_mem | free GPU memory in the relocatable heap
reloc_total_mem | total memory assigned to the GPU relocatable heap
sdram_c_volts | voltage provided to SOC SDRAM
sdram_i_volts | voltage provided to I/O SDRAM
sdram_p_volts | voltage provided to Physical SDRAM 
soc_temp | temperature of the SOC
uart_freq | clock frequency of the UART
v3d_freq | clock frequency of the V3D
vec_freq | clock frequency of the VEC
