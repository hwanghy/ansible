#!/bin/bash
#
# Run rsnapshot and show up the status to admin
#

_rsnap_cmd='/usr/bin/rsnapshot {{ weekly_plan_name }}'
_wan_ip=$(curl ip.tiki.cloud)

if ! $_rsnap_cmd ; then
  _msg="🚫NODE: $_wan_ip - Something went wrong when run $_rsnap_cmd. Please \
check the log file {{ backup_log }}. {{ telegram.admin }}"
else
  _msg="✅Node: $_wan_ip - rsnapshot backup successfully."
fi


curl -i -X GET \
  https://api.telegram.org/bot{{ telegram.token }}/sendMessage\?chat_id\={{ telegram.channel }}\&text\="$_msg"
