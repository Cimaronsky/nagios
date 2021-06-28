#!/bin/bash

# Script to check  security updates
# V.shahriari 03/29/2019 - V.1.0
#
# ------------------------------------------
# ########  Script Modifications  ##########
# ------------------------------------------
# Who    When      What
# ---    ----      ----
# Vahid  02/28/2019  update.
# IOnut 2019-04-22      bring it more in-line with nagios best practices
#

ECHO=/usr/bin/printf

#include nagios error codes
. /usr/lib*/nagios/plugins/utils.sh

if [ ! -e /etc/centos-release ]; then
        echo "ERROR: Not a CentOS distro!"
        exit $STATE_CRITICAL
fi

sec_updates=$(yum list-sec)
sec_upd_no=$(printf "${sec_updates}" | grep Sec | wc -l)

if  [ ${sec_upd_no} -eq  0 ] ; then
        ${ECHO} 'OK: No security updates available.'
        exit ${STATE_OK}
elif [  ${sec_upd_no} -ge 0 ] ; then
        upd=$(yum updateinfo -q)
        ${ECHO} "CRITICAL: ${upd}"
        exit ${STATE_CRITICAL}
else
        echo "UNKNOWN!"
        exit ${STATE_UNKNOWN}
fi
