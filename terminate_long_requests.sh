#!/bin/bash

OUTPUT_PATH='/tmp/5_min_req_master_132_terminated.csv'
psql -U postgres -c "COPY (SELECT pg_terminate_backend(pid), pid, now(), now()-xact_start as duration, query from pg_stat_activity where (now() - pg_stat_activity.xact_start) > '5 minutes'::interval and usename NOT IN ('postgres', 'backuper') and application_name<>'pg_dump'  and state<>'idle') TO PROGRAM 'cat >> ${OUTPUT_PATH}' CSV HEADER;"
