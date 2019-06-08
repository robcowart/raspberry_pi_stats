#!/bin/bash
#--------------------------------------------------------------------------------------------------
# MIT License
# Copyright 2019 Robert Cowart
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
# associated documentation files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute,
# sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#--------------------------------------------------------------------------------------------------

ts=$(date +%s%N)
rpi=$(hostname)
#cpu_t=$(</sys/class/thermal/thermal_zone0/temp)
#cpu_f=$(</sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
soc_t=$(/opt/vc/bin/vcgencmd measure_temp | sed -e "s/temp=//" -e "s/'C//")

arm_f=$(/opt/vc/bin/vcgencmd measure_clock arm | sed -e "s/^.*=//")
core_f=$(/opt/vc/bin/vcgencmd measure_clock core | sed -e "s/^.*=//")
h264_f=$(/opt/vc/bin/vcgencmd measure_clock h264 | sed -e "s/^.*=//")
isp_f=$(/opt/vc/bin/vcgencmd measure_clock isp | sed -e "s/^.*=//")
v3d_f=$(/opt/vc/bin/vcgencmd measure_clock v3d | sed -e "s/^.*=//")
uart_f=$(/opt/vc/bin/vcgencmd measure_clock uart | sed -e "s/^.*=//")
pwm_f=$(/opt/vc/bin/vcgencmd measure_clock pwm | sed -e "s/^.*=//")
emmc_f=$(/opt/vc/bin/vcgencmd measure_clock emmc | sed -e "s/^.*=//")
pixel_f=$(/opt/vc/bin/vcgencmd measure_clock pixel | sed -e "s/^.*=//")
vec_f=$(/opt/vc/bin/vcgencmd measure_clock vec | sed -e "s/^.*=//")
hdmi_f=$(/opt/vc/bin/vcgencmd measure_clock hdmi | sed -e "s/^.*=//")
dpi_f=$(/opt/vc/bin/vcgencmd measure_clock dpi | sed -e "s/^.*=//")

core_v=$(/opt/vc/bin/vcgencmd measure_volts core | sed -e "s/volt=//" -e "s/0*V//")
sdram_c_v=$(/opt/vc/bin/vcgencmd measure_volts sdram_c | sed -e "s/volt=//" -e "s/0*V//")
sdram_i_v=$(/opt/vc/bin/vcgencmd measure_volts sdram_i | sed -e "s/volt=//" -e "s/0*V//")
sdram_p_v=$(/opt/vc/bin/vcgencmd measure_volts sdram_p | sed -e "s/volt=//" -e "s/0*V//")

config_arm_f=$(($(/opt/vc/bin/vcgencmd get_config arm_freq | sed -e "s/arm_freq=//")*1000000))
config_core_f=$(($(/opt/vc/bin/vcgencmd get_config core_freq | sed -e "s/core_freq=//")*1000000))
config_gpu_f=$(($(/opt/vc/bin/vcgencmd get_config gpu_freq | sed -e "s/gpu_freq=//")*1000000))
config_sdram_f=$(($(/opt/vc/bin/vcgencmd get_config sdram_freq | sed -e "s/sdram_freq=//")*1000000))

arm_m=$(($(/opt/vc/bin/vcgencmd get_mem arm | sed -e "s/arm=//" -e "s/M//")*1000000))
gpu_m=$(($(/opt/vc/bin/vcgencmd get_mem gpu | sed -e "s/gpu=//" -e "s/M//")*1000000))
malloc_total_m=$(($(/opt/vc/bin/vcgencmd get_mem malloc_total | sed -e "s/malloc_total=//" -e "s/M//")*1000000))
malloc_m=$(($(/opt/vc/bin/vcgencmd get_mem malloc | sed -e "s/malloc=//" -e "s/M//")*1000000))
reloc_total_m=$(($(/opt/vc/bin/vcgencmd get_mem reloc_total | sed -e "s/reloc_total=//" -e "s/M//")*1000000))
reloc_m=$(($(/opt/vc/bin/vcgencmd get_mem reloc | sed -e "s/reloc=//" -e "s/M//")*1000000))

oom_c=$(/opt/vc/bin/vcgencmd mem_oom | grep "oom events" | sed -e "s/^.*: //")
oom_t=$(/opt/vc/bin/vcgencmd mem_oom | grep "total time" | sed -e "s/^.*: //" -e "s/ ms//")

mem_reloc_alloc_fail_c=$(/opt/vc/bin/vcgencmd mem_reloc_stats | grep "alloc failures" | sed -e "s/^.*:[^0-9]*//")
mem_reloc_compact_c=$(/opt/vc/bin/vcgencmd mem_reloc_stats | grep "compactions" | sed -e "s/^.*:[^0-9]*//")
mem_reloc_leg_blk_fail_c=$(/opt/vc/bin/vcgencmd mem_reloc_stats | grep "legacy block fails" | sed -e "s/^.*:[^0-9]*//")

#echo "raspberry_pi,host=${rpi} cpu_temp=$((cpu_t/1000)).$((cpu_t%1000)),cpu_freq=$((cpu_f*1000))i,gpu_temp=${gpu_t} ${ts}"
echo "raspberry_pi,host=${rpi} soc_temp=${soc_t},arm_freq=${arm_f}i,core_freq=${core_f}i,h264_freq=${h264_f}i,isp_freq=${isp_f}i,v3d_freq=${v3d_f}i,uart_freq=${uart_f}i,pwm_freq=${pwm_f}i,emmc_freq=${emmc_f}i,pixel_freq=${pixel_f}i,vec_freq=${vec_f}i,hdmi_freq=${hdmi_f}i,dpi_freq=${dpi_f}i,core_volts=${core_v},sdram_c_volts=${sdram_c_v},sdram_i_volts=${sdram_i_v},sdram_p_volts=${sdram_p_v},config_arm_freq=${config_arm_f}i,config_core_freq=${config_core_f}i,config_gpu_freq=${config_gpu_f}i,config_sdram_freq=${config_sdram_f}i,arm_mem=${arm_m}i,gpu_mem=${gpu_m}i,malloc_total_mem=${malloc_total_m}i,malloc_mem=${malloc_m}i,reloc_total_mem=${reloc_total_m}i,reloc_mem=${reloc_m}i,oom_count=${oom_c}i,oom_ms=${oom_t}i,mem_reloc_allocation_failures=${mem_reloc_alloc_fail_c}i,mem_reloc_compactions=${mem_reloc_compact_c}i,mem_reloc_legacy_block_failures=${mem_reloc_leg_blk_fail_c}i"
