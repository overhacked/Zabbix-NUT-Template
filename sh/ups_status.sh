#!/bin/sh
 
UPSC_CMD=/usr/local/bin/upsc

ups=${1:?'UPS name or ups.discovery must be first parameter.'}

if [ $ups = ups.discovery ]; then

	# Put newlines at the semicolons to make this more readable
    $UPSC_CMD -L 2>&1 | awk 'BEGIN { FS=":"; printf "{\"data\":[" }; !/(SSL|^Error:)/ { if (NR > 1) printf ","; printf "{\"{\#UPSNAME}\":\"%s\",\"{\#UPSDESC}\":\"%s\"}", $1, substr($2,2) }; END { printf "]}" }'

else

key=${2:?'Item key must be specified.'}
statusval=$($UPSC_CMD $ups $key 2>&1 | grep -v SSL)

if [ $key = ups.status ]; then
	retval=0
	for state in $statusval; do
		case $state in
			OVER)		retval=$(($retval | 512)) ;; #'UPS is overloaded' ;;
			TRIM)		retval=$(($retval | 1024)) ;; #'UPS is trimming incoming voltage (called "buck" in some hardware)' ;;
			BOOST)		retval=$(($retval | 2048)) ;; #'UPS is boosting incoming voltage' ;;
			OL)		retval=$(($retval | 1)) ;; #'On line (mains is present)' ;;
			OB)		retval=$(($retval | 2)) ;; #'On battery (mains is not present)' ;;
			LB)		retval=$(($retval | 4)) ;; #'Low battery' ;;
			RB)		retval=$(($retval | 8)) ;; #'The battery needs to be replaced' ;;
			CHRG)		retval=$(($retval | 16)) ;; #'The battery is charging' ;;
			DISCHRG)	retval=$(($retval | 32)) ;; #'The battery is discharging (inverter is providing load power)' ;;
			BYPASS)		retval=$(($retval | 64)) ;; #'UPS bypass circuit is active echo no battery protection is available' ;;
			CAL)		retval=$(($retval | 128)) ;; #'UPS is currently performing runtime calibration (on battery)' ;;
			OFF)		retval=$(($retval | 256)) ;; #'UPS is offline and is not supplying power to the load' ;;
			*)		retval=$(($retval | 0)) ;; #'unknown state' ;;
		esac;
	done
	echo $retval
else
	case ${statusval} in
		*"Variable not supported"*)
			echo ""
			exit 0
			;;
		"Error: "*)
			printf "%s" "${statusval}"
			exit 1
			;;
		*)
			printf "%s" "${statusval}"
			;;
	esac
fi

fi

