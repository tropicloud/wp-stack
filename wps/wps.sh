#!/usr/bin/env bash

# ------------------------
# Tropicloud's WP-STACK
# ------------------------
# @author: Guigo (guigo.pw)
# version: 0.1
# ------------------------

# load environment
. /usr/local/wps/wps-env.sh

# load functions
for f in /usr/local/wps/func/*; do . $f; done

echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"
echo "DB_NAME: $DB_NAME"
echo "DB_USER: $DB_USER"
echo "DB_PASS: $DB_PASS"

# ------------------------
# WP-STACK Functions
# ------------------------

  if [[  ${1} == 'setup'  ]];	then wps_setup
elif [[  ${1} == 'start'  ]];	then wps_start
elif [[  ${1} == 'stop'  ]];	then wps_stop

# ------------------------
# WP-STACK Commands
# ------------------------

else echo "
----------------------------------------------------
  WP-STACK  - www.tropicloud.net
----------------------------------------------------  

  HOW TO USE:
  
  wps info <hostname>
  wps create --hostname=<hostname>
  wps destroy -c --confirm <hostname>
  wps add <hostname>
  wps drop <hostname>
  wps import <hostname>
  wps export <hostname>
  wps backup <hostname> --all
  wps dbprefix
  wps image

----------------------------------------------------  

"
fi
