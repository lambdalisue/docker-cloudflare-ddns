#!/bin/bash
if [[ -z $CRON_SCHEDULE ]]; then
  export CRON_SCHEDULE="30 * * * *"
fi
cat /crontab.template \
  | sed -e "s/CRON_SCHEDULE/$CRON_SCHEDULE/g" \
  > /var/spool/cron/crontabs/root

crond -l 2 -f
