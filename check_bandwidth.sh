#!/bin/sh
PROGNAME='Check_Bandwidth VER 1.0'
VST='vnstat'
$VST -u
	CMD="${CMD}`$VST $1 $2 $3 $4 $5 > output.$1.$2.$3.$4.$5.log`"
	`$CMD`
	sleep 5
	OUTPUT=" ${OUTPUT} `sed '1d' output.$1.$2.$3.$4.$5.log`"
	chmod 777 output.$1.$2.$3.$4.$5.log
	STAT=0
	echo $OUTPUT
	sleep 4
	rm output.$1.$2.$3.$4.$5.log
exit $STAT

