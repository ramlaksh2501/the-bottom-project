#!/bin/bash
function cleanup() {
    echo "exiting"
    sleep 3
    tput cnorm
    clear
    exit 1
}
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
	echo "$memory_used/$total_mem"
	sleep 1
	clear
done




#to catch the ctrl + c signal 

