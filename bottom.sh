#!/bin/bash
function cleanup() {
    echo "exiting"
    tput cnorm
    clear
    exit 1
}
#to catch the ctrl + c signal 
trap 'cleanup' SIGINT


total_mem=$(cat /proc/meminfo | head -n 1 | cut -d ':' -f 2 | cut -d 'k' -f 1)
total_mem=$(echo "print(round(($total_mem/1048576),2))" | python3)

tput civis # to hide the cursor 	
clear	
while true
do

	memory_used=$(cat /proc/meminfo | head -n 3 | tail -n 1 | cut -d ':' -f 2 | cut -d 'k' -f 1)
        memory_used=$(echo "print(round(($memory_used/1048576),2))" | python3)
	memory_used=$(echo "print($total_mem - $memory_used)" | python3)
	uptime -p 
	echo "mem : $memory_used G / $total_mem G "
	echo -ne "CPU Temperature : "
	sensors | awk "NR == 8" | awk '{print $2}'

	pre_cpu_user=$(cat /proc/stat | head -n 1 | awk '{print $2}')
	pre_cpu_nice=$(cat /proc/stat | head -n 1 | awk '{print $3}')
	pre_cpu_system=$(cat /proc/stat | head -n 1 | awk '{print $4}')
	pre_cpu_idle=$(cat /proc/stat | head -n 1 | awk '{print $5}')
	pre_cpu_iowait=$(cat /proc/stat | head -n 1 | awk '{print $6}')
	pre_cpu_irq=$(cat /proc/stat | head -n 1 | awk '{print $7}')
	pre_cpu_softirq=$(cat /proc/stat | head -n 1 | awk '{print $8}')
	pre_cpu_steal=$(cat /proc/stat | head -n 1 | awk '{print $9}')
	pre_cpu_guest=$(cat /proc/stat | head -n 1 | awk '{print $10}')
	pre_cpu_nice_guest=$(cat /proc/stat | head -n 1 | awk '{print $11}')
	sleep 0.1
	cur_cpu_user=$(cat /proc/stat | head -n 1 | awk '{print $2}')
	cur_cpu_nice=$(cat /proc/stat | head -n 1 | awk '{print $3}')
	cur_cpu_system=$(cat /proc/stat | head -n 1 | awk '{print $4}')
	cur_cpu_idle=$(cat /proc/stat | head -n 1 | awk '{print $5}')
	cur_cpu_iowait=$(cat /proc/stat | head -n 1 | awk '{print $6}')
	cur_cpu_irq=$(cat /proc/stat | head -n 1 | awk '{print $7}')
	cur_cpu_softirq=$(cat /proc/stat | head -n 1 | awk '{print $8}')
	cur_cpu_steal=$(cat /proc/stat | head -n 1 | awk '{print $9}')
	cur_cpu_guest=$(cat /proc/stat | head -n 1 | awk '{print $10}')
	cur_cpu_nice_guest=$(cat /proc/stat | head -n 1 | awk '{print $11}')

	pidle=$((pre_cpu_idle + pre_cpu_iowait))
	cidle=$((cur_cpu_idle + cur_cpu_iowait))

	pre_total=$((pre_cpu_user + pre_cpu_nice + pre_cpu_system + pre_cpu_irq + pre_cpu_softirq + pre_cpu_steal))
	cur_total=$((cur_cpu_user + cur_cpu_nice + cur_cpu_system + cur_cpu_irq + cur_cpu_softirq + cur_cpu_steal))

	ptotal=$((pidle + pre_total))      
	ctotal=$((cidle + cur_total))      

	totald=$((ctotal - ptotal))        
	idled=$((cidle - pidle))           

	cpu_per=$(( (totald - idled) * 100 / totald ))
	echo "CPU Usage : $cpu_per %"

	sleep 0.5	
	clear
done





