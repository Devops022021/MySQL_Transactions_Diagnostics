#!/bin/bash

host="hostname"
user="DB_super_user"
password="DB_Super_Password "
outputDir="/home/diag_dump/"

# c="mysql -h${host} -u${user} -p${password} --batch"
  c="mysql --login-path=evengroupdb --batch"

###########################################
#        declare -A queries               #
###########################################

queries[processlist]='SELECT * FROM information_schema.processlist'
queries[globalstatus]='SHOW GLOBAL STATUS'
queries[innodbstatus]='SHOW ENGINE INNODB STATUS\G'
queries[trx]='SELECT * FROM information_schema.innodb_trx\G'
queries[trxwaits]='SELECT r.trx_id waiting_trx_id, r.trx_mysql_thread_id waiting_thread, r.trx_query waiting_query, b.trx_id blocking_trx_id, b.trx_mysql_thread_id blocking_thread, b.trx_query blocking_query FROM information_schema.innodb_lock_waits w INNER JOIN information_schema.innodb_trx b ON b.trx_id = w.blocking_trx_id INNER JOIN information_schema.innodb_trx r ON r.trx_id = w.requesting_trx_id\G'

outputFilePrefix="${outputDir}/`date -u +%s`_"

for q in "${!queries[@]}"
do
   outputFileName="${outputFilePrefix}${q}.txt"
   $c -e "${queries[$q]}" > $outputFileName 2>/dev/null
done
