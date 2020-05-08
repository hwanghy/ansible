#!/bin/bash
#
# This script is used to backup mysql use inno backup
#


_backup_user='{{ backup_user }}'
_backup_password='{{ backup_password }}'
_backup='{{ backup_dir }}'
_log="/var/log/mysql_innobackup.log"
_today=$(date +%d-%m-%Y)
_tar_type="tar.zst"
_rotate='7'
_server_ip=$(curl -s http://ip.tiki.cloud)
_threshold=80

# env preparing
[ ! -d $_backup ] && mkdir -p $_backup

_disk_check=$(df -hT $_backup | tail -n +2 \
  | grep -- '%' \
  | awk '{print $(NF -1)}' \
  | cut -d'%' -f1 \
)

echo "$(date) - Begin to run mysql backup" | tee -a $_log 2>&1

if [[ "$_disk_check" -ge "$_threshold"  ]]; then

  _msg="🚫NODE: $_server_ip - Backup ignored, $_backup \
is nearly full space: $_disk_check%. {{ telegram.admin }}"
  _alert=1

else

  # run backup
  sh -c "xtrabackup --backup \
      --user=$_backup_user \
      --password=$_backup_password \
      --target-dir=$_backup/ \
      --stream=tar \
      | zstd -1 > $_backup/$_today-mysql.$_tar_type" \
      >  $_log 2>&1
  _alert=$?

  # backup rotation
  find $_backup -type f \
      -mtime +$_rotate \
      -name "*.$_tar_type" \
      -delete \
      > $_log 2>&1
  _alert=$?

  echo "$(date) - Finished run mysql backup" | tee -a $_log

  # notify
  if [[ "$_alert" == 0 ]]; then
    #statements
    _msg="✅Node: $_server_ip - Mysql successfully backed up.\
    File path is: $_backup/$_today-mysql.$_tar_type"
  else
    _msg="🚫NODE: $_server_ip - Something went wrong when run mysql backup. Please \
  take a look at $_log. {{ telegram.admin }}"
  fi
fi

curl -i -X GET \
  https://api.telegram.org/bot{{ telegram.token }}/sendMessage\?chat_id\={{ telegram.channel }}\&text\="$_msg"
echo $_msg | tee -a $_log
exit $_alert
