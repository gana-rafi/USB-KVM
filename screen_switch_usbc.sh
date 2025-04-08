#!/usr/bin/bash
# Debugging test script called by udev

# File paths, to be customized as we need
logFile="/tmp/udev_kvm_switch.txt"
dateFile="/tmp/.udev_kvm_switch.date"

# Ensure only one instance is running at a time
# Info: https://www.baeldung.com/linux/bash-ensure-instance-running#2-using-lsof
instances=`lsof -t "$0" | wc -l`
if (( $instances > 1 )); then exit 1; fi

# Prevent multiple executions inside a 3-sec time frame
if [ ! -f $dateFile ]; then
    echo "lastExecution=0" > $dateFile
fi
. $dateFile # reads the $lastExecution var from file
timeframe=$(( $(date +%s) - $lastExecution )) # seconds from last execution
if (( $timeframe <= 3 )); then exit 1; fi
echo "lastExecution=$(date +%s)" > $dateFile

# Debugging info
echo -e "---\n"                             >> $logFile
date                                        >> $logFile
echo "USB Device '$1' plugged in..."        >> $logFile
echo "Current symlinks (in /dev dir): "$2   >> $logFile
echo "Name of the device node: "$3          >> $logFile
echo "Vendor ID: "$ID_VENDOR_ID             >> $logFile
echo "Model ID: "$ID_MODEL_ID               >> $logFile
echo "Environment \$PATH var: " $PATH       >> $logFile
echo -e "---\n"                             >> $logFile
echo "Full list of environment variables:"  >> $logFile
printenv                                    >> $logFile
echo -e "---\n"                             >> $logFile

# Do other stuff...

ddcutil setvcp '0x60' '0x1b' # 60 (Input Source) 1b: usb-c
exit 0

#ATTR{idVendor}=="045e", ATTR{idProduct}=="07a5"
