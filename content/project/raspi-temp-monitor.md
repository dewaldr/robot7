+++
title = "Raspberry Pi temperature monitor"
description = "This lightweight Nagios plugin will allow you to remotely monitor the CPU and GPU temperature of your overclocked Raspberry Pi."
date = "2017-06-15T12:00:00+02:00"
tags = ["nagios","raspberry-pi","overclocking"]
categories = ["coding","network-monitor"]
+++

[//]: # (TODO:  Add links to GitHub page)

A lightweight Nagios plugin to remotely monitor the CPU and GPU temperature of your overclocked Raspberry Pi.

# Overclocking a Raspberry Pi
I have several Raspberry Pi 1 Model B's lying around and put them to use in our farm network whenever I can. Although 
these inexpensive boards have been superceded by the much more capable <a href="https://www.raspberrypi.org/products/raspberry-pi-3-model-b/">
Raspberry Pi 3</a>, they are rock solid and make excellent low power servers using <a href="http://raspbian.org/">Raspbian</a> and its 
derivatives. 

{{< img src="/img/raspberrypimodelb.jpg" caption="The Model B" >}}

Sometimes it may be neccecary to boost performance a bit by overclocking the CPU, as in the case of my motion detection
server. I use the really useful open source <a href="https://github.com/ccrisan/motioneye">MotionEye</a> software to monitor
a solar powered camera at the main gate of the farm. More about that later. 

Overclocking the Raspberry Pi is easily accomplished by modifying the contents of the `/boot/config.txt` file. 
Here are my settings that allows the ARM CPU to scale to a maximum of 950MHz and reduces the memory 
portioned off to the graphics sub-system to the minimum possible, namely 16MB.

```
    arm_freq     = 950
    core_freq    = 250
    sdram_freq   = 450
    over_voltage = 6
    gpu_mem      = 16
```

Modern versions of Raspbian include the `raspi-config` utility which makes this setup very easy. 

# Passive cooling
The Raspberry Pi in question is only passively cooled and therefore overheating becomes a problem, especially during the hot African 
summer months. I wrote a lightweight plugin for <a href="https://www.nagios.org/projects/nagios-core/">Nagios Core</a> to monitor the 
system temperature.

The Nagios server, also a Raspberry Pi, monitors the health of the rest of our FAN (Farm Area Network), and does doubles duty as the DHCP, DNS and OpenVPN 
server.


# The plugin
I wrote the plugin in Bash as it is one of my favourite tools and you can see the internals working, as you would be able to with  a 
classic car. I guess when I get over this silly notion I'll rewrite it in Python or C++ ;o)

{{< highlight Bash >}}

#!/bin/bash

REVISION="0.1.0"
BC="/usr/bin/bc"
CAT="/bin/cat"
SED="/bin/sed"

# Initialize variables to default values:
warn_cpu_temp=68.0
crit_cpu_temp=74.0
cpu_temp=0

show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-w WARNING_TEMP] [-c CRITICAL_TEMP]

    -h                  display this help and exit
    -w WARNING_CPU_TEMP     warning temperature limit [default: $warn_cpu_temp]
    -c CRITICAL_CPU_TEMP    critical temperature limit [default: $crit_cpu_temp]
EOF
}

# Get command line options
OPTIND=1
while getopts hc:w: opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        c)  crit_cpu_temp=$OPTARG
            ;;
        w)  warn_cpu_temp=$OPTARG
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.

get_cpu_temp() {
    local cpuTemp0=$($CAT /sys/class/thermal/thermal_zone0/temp)
    local cpuTemp1=$(($cpuTemp0/1000))
    local cpuTemp2=$(($cpuTemp0/100))
    local cpuTempM=$(($cpuTemp2 % $cpuTemp1))

    echo "$cpuTemp1.$cpuTempM"
}

get_gpu_temp() {
    local gpuTemp=$(/opt/vc/bin/vcgencmd measure_temp | $SED -nr "s/.*=(.*)'.*/\1/p")
    echo "$gpuTemp"
}

cpu_temp=$(get_cpu_temp)
gpu_temp=$(get_gpu_temp)

if (( $($BC <<< "$cpu_temp > $crit_cpu_temp") )); then
    echo "TEMP CRITICAL - CPU: $cpu_tempºC, GPU: $gpu_tempºC"
    exit 2
elif (( $($BC <<< "$cpu_temp > $warn_cpu_temp") )); then
    echo "TEMP WARNING - CPU: $cpu_tempºC, GPU: $gpu_tempºC"
    exit 1
else
    echo "TEMP OK - CPU: $cpu_tempºC, GPU: $gpu_tempºC"
    exit 0
fi

echo "UNKOWN - $cpu_temp,$gpu_temp"
exit 3

{{< /highlight >}}

# Conclusion
It generaly seems a to be good idea to ensure operating conditions for all your systems are perfect. However, in the real world 
a less than optimal solution usually works best and is cheaper to implement and run. I could have installed an inexpensive fan to keep
the overclocked CPU cool, but that would have added to the running cost, electicity use and have increased the noise level in my office. 

Having the network monitoring system alert me once or twice a year seems to be a nice compromise.

