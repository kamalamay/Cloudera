SELECT NAME,DB_UNIQUE_NAME,/*FORCE_LOGGING,*/LOG_MODE,OPEN_MODE,DATABASE_ROLE,SWITCHOVER_STATUS,CURRENT_SCN FROM V$DATABASE;

SELECT NAME,DB_UNIQUE_NAME,DATABASE_ROLE FROM V$DATABASE;

SELECT /*Check Gap on Stby*/ al.thrd "Thread", almax "Last Seq Received", lhmax "Last Seq Applied" FROM (select thread# thrd, MAX(sequence#) almax
FROM v$archived_log WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) GROUP BY thread#) al, (SELECT thread# thrd, MAX(sequence#) lhmax
FROM v$log_history WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) GROUP BY thread#) lh WHERE al.thrd = lh.thrd;

--Check process on Standby
SELECT SEQUENCE#, APPLIED FROM V$ARCHIVED_LOG;

RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION /*Start MRP*/;
RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION /*Start MRP RealTime*/;
RECOVER MANAGED STANDBY DATABASE CANCEL /*Stop MRP*/;

ALTER DATABASE REGISTER LOGFILE '&arc';

--Check proses standby
SELECT PROCESS, STATUS FROM V$MANAGED_STANDBY;
SELECT SEQUENCE#, APPLIED FROM V$ARCHIVED_LOG;
SELECT PROCESS,STATUS,SEQUENCE# FROM V$MANAGED_STANDBY;
SELECT MAX(SEQUENCE#) FROM V$ARCHIVED_LOG/*Primary*/;
SELECT MAX(SEQUENCE#) FROM V$ARCHIVED_LOG WHERE APPLIED='YES';

SELECT /*Check dest error*/ thread#, dest_id, gvad.status, error, fail_sequence FROM gv$archive_dest gvad, gv$instance gvi
WHERE gvad.inst_id = gvi.inst_id AND destination is NOT NULL ORDER BY thread#, dest_id;
