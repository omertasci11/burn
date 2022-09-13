#!/bin/bash

echo ""
echo "                \||/"
echo "                |  @___oo"
echo "      /\  /\   / (__,,,,|                   (        )   "
echo "     ) /^\) ^\/ _)               (          )\ )  ( /(   "
echo "     )   /^\/   _)             ( )\     (  (()/(  )\())  "
echo "     )   _ /  / _)             )((_)    )\  /(_))((_)\   "
echo " /\  )/\/ ||  | )_)           ((_)_  _ ((_)(_))   _((_)  "
echo "<  >      |(,,) )__)           | _ )| | | || _ \ | \| |  "
echo " ||      /    \)___)\          | _ \| |_| ||   / |    |  "
echo " | \____(      )___) )___      |___/ \___/ |_|_\ |_|\_|  "
echo "  \______(_______;;; __;;;"




echo -e "\n Welcome to Anti-Forensic tool Burn!! "

#Array containing the path of log files
declare -a logPaths 

case $1 in

	-h | --help)
		echo -e "
[deleting logs]
-s, --selected <file path>    delete seleced log file 
-l, --all                     delete all Log files

[changing timestamps]
-t, --timestamps <file path>  
	-z                    sets the timestamp to zero
	-r                    sets the timestamp a random date
	-s                    transfers timestamp from file to file
	-g                    sets the given date as a timestamp

[deleting history]
-c , --history                clearing command line history

[All in one]
-x, --terminate               deleting all logs, changing timestamps, 
			      clearing command line history
			      changing MAC address

[background]
-b , --background             run in background

[diff]
-d --diff                     compares before and after script

[help]
-h , --help                   display this help

Usage: burn.sh [ -s file path ] [-all]
	       	[ -t ]          [ -z ][ -r ][ -s ][ -g ] 
		[ -c ]                  
	       	[ -x ]
		[ -b ]
	       	[ -h ]
			"
	;;

	-s | --selected)

		filePath=$2
		

		if [ "$2" != "" ]
		then
			shred=$(sudo shred -z -n 3 $filePath)
			echo $shred
			content=$(sudo true > $filePath)
			echo $content
			sleep 1
			echo "Done!"
			echo -n "Cleared log file: $filePath"
		else
		    echo -e "\nerror: './burn.sh --help' for more information."
		fi

        ;;
	-l | --all)

		echo $(find /var/log -type f -printf "%T@ %p\n" | sort -nr | cut -d\  -f2- > /root/logs.txt)

		input="/root/logs.txt"
		while IFS= read -r line
		do	
			if [[ $line = *log ]];
			then
  				logPaths+=($line)
			fi
		done < "$input"


		len=${#logPaths[@]} 
		echo -e "Number of detected log files: $len\n"


		for i in "${logPaths[@]}"; do
			
			shred=$(sudo shred -z -n 3 $i)
    		content=$(sudo true > $i)
			echo "Clearing... $i"
			sleep 0.2     
		done
			
			echo "Done!"; 
			
		;;

	-t |--timestamps)
		
		if [ "$2" == "-z" ];
		then
			if [ "$3" != "" ]
			then
			    systemDate=$(date --set="@18000")
				set=$(hwclock --systohc)

				filePath=$3
				changeDate=$(sudo touch -c -am -d"@18000" $filePath)
				echo $changeDate
				echo "Timestamps change !"

				currentDate=$(date)
				echo $currentDate

				systemDate=$(date -d $currentDate)

				set=$(hwclock --systohc)
				
			else
		    	echo -e "\nerror: './burn.sh --help' for more information."

			fi
			
		#random Date
		elif [ "$2" == "-r" ];
		then
			filePath=$3

			randomDate=$(date -d "$((RANDOM%1+2010))-$((RANDOM%12+1))-$((RANDOM%28+1)) $((RANDOM%23+1)):$((RANDOM%59+1)):$((RANDOM%59+1))" '+%Y-%m-%d %H:%M:%S')

			if [[ "$3" != "" && "$4" == "" ]]
			then
				#we have the opportunity to change the change time by changing sytem time
				currentDate=$(date)

			    systemDate=$(date --set="$randomDate")

				set=$(hwclock --systohc)

				changeDate=$(sudo touch -c -am -d $randomDate $filePath)
				echo $changeDate
				echo "Timestamps change !"
			    
				systemDate=$(date --set="$currentDate")

				set=$(hwclock --systohc)

			else
		    	echo -e "\nerror: './burn.sh --help' for more information."

			fi
		#file to file date transfer
		elif [ "$2" == "-s" ]
		then

			if [[ "$3" != "" && "$4" != "" ]]
			then

				changeDate=$(sudo touch -am -r $3 $4)
				echo $changeDate
				echo "Timestamps change !"

			else
		    	echo -e "\nerror: './burn.sh --help' for more information."

			fi
		#given date 
		elif [ "$2" == "-g" ]
		then
			
			if [[ "$3" != "" && "$4" == "" ]]
			then
				
				filePath=$3
				echo ""
				read -p "YYYY:" YYYY
				read -p "MM:" MM
				read -p "DD:" DD
				read -p "hh:" hh
				read -p "mm:" mm
				read -p "ss:" ss	
				userDate=$(date -d "$YYYY-$MM-$DD $hh:$mm:$ss" '+%Y-%m-%d %H:%M:%S')
				
				currentDate=$(date)

			    systemDate=$(date --set="$userDate")
				
				set=$(hwclock --systohc)
				
				changeDate=$(sudo touch -c -am -d $userDate $filePath)
				echo $changeDate
				echo "Timestamps change !"

				systemDate=$(date --set="$currentDate")
				
				set=$(hwclock --systohc)
				

			else
		    	echo -e "\nerror: './burn.sh --help' for more information."

			fi


		else
		    	echo -e "\nerror: './burn.sh --help' for more information."

		fi

		
		
	;;
	-c | --history)
		
		path=$(echo $SHELL)

		pars=$(echo $path | tr "/" "\n")

		for i in $pars
		do  
    		if [[ "$i" != "usr" || "$i" != "bin" ]];
    		then
        	shellType=$i
    		fi
		done

		#echo $shellType
		#echo "/root/."$shellType"_history"

		deleteHistory=$(sudo true > /root/."$shellType"_history)
		echo $deleteHistory 

		echo "History has been deleted."

	;;

	-x | --terminate)
		#logs
        echo $(find /var/log -type f -printf "%T@ %p\n" | sort -nr | cut -d\  -f2- > /root/logs.txt)

		input="/root/logs.txt"
		while IFS= read -r line
		do
  			if [[ $line = *log ]];
			then
  				logPaths+=($line)
			fi
		done < "$input"


		for i in "${logPaths[@]}"; do
    		shred=$(sudo shred -z -n 3 $i)
			content=$(sudo true > $i)
			
		done

		sleep 0.2
		echo "Log files has been deleted."
		
		#history
		path=$(echo $SHELL)

		pars=$(echo $path | tr "/" "\n")

		for i in $pars
		do  
    		if [[ "$i" != "usr" || "$i" != "bin" ]];
    		then
        	shellType=$i
    		fi
		done

		#echo $shellType
		#echo "/root/."$shellType"_history"

		deleteHistory=$(sudo true > /root/."$shellType"_history)
		echo $deleteHistory 

		sleep 0.2
		echo "History has been deleted."

		#echo "System is shutting down..."
#
		#sleep 3
#
		#shutDown=$(sudo shutdown -h now)
		#echo $shutDown
		

	;;

	-b | --background)
		
		echo $(find /var/log -type f -printf "%T@ %p\n" | sort -nr | cut -d\  -f2- > /root/logs.txt)

		input="/root/logs.txt"
		while IFS= read -r line
		do
  			if [[ $line = *log ]];
			then
  				logPaths+=($line)
			fi
		done < "$input"

		for i in "${logPaths[@]}"; do
			shred=$(sudo shred -z -n 3 $i)
    		content=$(sudo true > $i)
			echo $i
		done

		path=$(echo $SHELL)

		pars=$(echo $path | tr "/" "\n")

		for i in $pars
		do  
    		if [[ "$i" != "usr" || "$i" != "bin" ]];
    		then
        	shellType=$i
    		fi
		done

		deleteHistory=$(sudo true > /root/."$shellType"_history)
		echo $deleteHistory 

		echo "History has been deleted."
		
		echo $(date) >> status.txt
		#Here, every time a cron job runs, it enters the date information in the status file.
			
	;;

	-d | --diff)

	diff=$(diff /root/hash.source /root/hash.dest > changes.diff )

	echo -e "\n Changed files; \n"
	
	input="/root/changes.diff"
	while IFS= read -r line
	do
		if [[ $line = "<"* ]];
    	then
        	echo $line 
    	fi

	done < "$input"

	;;

	*)
	    echo -e "\nTry './burn.sh --help' for more information."
    ;;

esac


