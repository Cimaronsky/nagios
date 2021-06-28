#!/bin/bash

# Script to check updates for outdated packages
# Add command[check_updates]=/usr/lib/nagios/plugins/check_update.sh [-w 0] [-s 999] [-q]
# in nrpe.conf
#
# V.shahriari 02/28/2019 - V.1.0
# ------------------------------------------
# ########  Script Modifications  ##########
# ------------------------------------------
# Who    When      What
# ---    ----      ----
# Vahid  02/28/2019  update.
# Cristi/Ionut  11/04/2019      code refactoring with NRPE best practices and making it more portable
# IOnut 2019-04-22      run w/o args with defaults; also by def. print outdated packages (-q to quiet)
#

int_warn=0
int_crit=999

ECHO=/usr/bin/printf

# get arguments
while getopts 'w:c:hq' OPT; do
  case $OPT in
    w)  int_warn=$OPTARG;;
    c)  int_crit=$OPTARG;;
    h)  hlp="yes";;
    q)  print_details=false;;
    *)  unknown="yes";;
  esac
done

# usage
HELP="
    usage: $0 [ -w value -c value -p -h ]

    syntax:

            -w --> Warning integer value
            -c --> Critical integer value
            -q --> don't print outdated packages
            -h --> print this help screen
"

if [ "$hlp" = "yes" ]; then
  echo "$HELP"
  exit 0
fi

ECHO=/usr/bin/printf

#include nagios error codes
. /usr/lib*/nagios/plugins/utils.sh

#if [ ! -e /etc/centos-release ]; then
#        echo "ERROR: Not a CentOS distro!"
#        exit $STATE_CRITICAL
#fi

if [ $int_warn -gt $int_crit ]; then
                ${ECHO} "ERROR: warning value must be smaller than critical value"
                exit $STATE_CRITICAL
fi

updates=$(yum check-update | grep -A  10000 '^$' | cut -d ' ' -f1)
number_of_updates=$(printf "$updates" | wc -l)

if  [ $number_of_updates -gt $int_warn -a $number_of_updates -lt $int_crit ] ; then
        $print_details && ${ECHO} "WARNING:  $STATE_WARN There are $number_of_updates updates available. $updates\n" || \
                 ${ECHO} "WARNING: There are $number_of_updates updates available."
        exit $STATE_WARNING
elif [ $number_of_updates -ge $int_crit ] ; then
        $print_details && ${ECHO} "CRITICAL: There are $number_of_updates updates available. $updates\n" || \
                ${ECHO} "WARNING: There are $number_of_updates updates available."
        exit $STATE_CRITICAL
else
        echo -n "OK: There are $number_of_updates updates available."
        exit $STATE_OK
fi

