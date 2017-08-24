#!/bin/sh
 
UPSC_CMD=/usr/local/bin/upsc

ups=${1:?'UPS name or ups.discovery must be first parameter.'}

if [ $ups = ups.discovery ]; then

    echo -n '{"data":['
    first=1
    $UPSC_CMD -l 2>&1 | grep -v SSL | while read discovered ; do 
        if [ $first -eq 0 ]; then
            echo -n ','
        fi
        printf '{"{#UPSNAME}":"%s"}' "$discovered"
        first=0
    done
    echo -n ']}'

else

key=${2:?'Item key must be specified.'}

if [ $key = ups.status ]; then
	statusval=$($UPSC_CMD $ups $key 2>&1 | grep -v SSL)
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
	$UPSC_CMD $ups $key  2>&1 | grep -v SSL
fi

fi

