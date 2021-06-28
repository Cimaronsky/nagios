#!/bin/sh

fila_post=`postqueue -p |grep -e "^[A-Z,0-9]" | grep -v "Mail" |wc -l`
crit=50
warn=70

if [ $fila_post -gt $warn ]; then
        if [ $fila_post -le $crit ]; then
        echo "WARNING: postqueue -p -> $fila_post"
        exit 1
        fi
fi
if [ $fila_post -gt $crit ]; then
        echo "CRITICAL: postqueue -p > $fila_post"
        exit 2
fi
if       [ $fila_post -le $warn ]; then

        echo "OK: postqueue -p -> $fila_post"
        exit 0
fi
