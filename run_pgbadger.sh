#!/bin/bash
date=`date +%F`
hour=`date +%H`
servers="132 133"

#copy all logs for full day if script was run at 23:59
if [ "$hour" -eq "23" ]
   then
   sleep 3m
fi

#copy postgres logs to our server
for i in $servers
   do
   rsync --inplace --no-whole-file root@192.168.0."$i":/var/log/postgresql/postgresql-"$date".log /mnt/pgbadger/"$i"_logs/
done

for i in $servers
   do
   #if first start in day (at 12am), run pgbadger without -l option
   if [ "$hour" -eq "12" ]
      then
      /mnt/pgbadger/pgbadger/pgbadger -H /mnt/pgbadger/"$i"_reports -O /mnt/pgbadger/"$i"_bin -I -j 8  -p '%m %p %u@%d from %h [vxid:%v txid:%x] [%i]' -R 4  /mnt/pgbadger/"$i"_logs/postgresql-"$date".log
   else
      /mnt/pgbadger/pgbadger/pgbadger -H /mnt/pgbadger/"$i"_reports -O /mnt/pgbadger/"$i"_bin -I -j 8  -p '%m %p %u@%d from %h [vxid:%v txid:%x] [%i]' -R 4 -l /mnt/pgbadger/"$i"_logs/postgresql-"$date".log  /mnt/pgbadger/"$i"_logs/postgresql-"$date".log
   fi   
   #remove unnecessary logs if run last
   if [ "$hour" -eq "23" ]
      then
      rm /mnt/pgbadger/"$i"_logs/postgresql-"$date".log
   fi
done
