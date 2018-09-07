BEGIN
  -- Job defined entirely by the CREATE JOB procedure.
  DBMS_SCHEDULER.create_job (
    job_name        => 'Gather_scott',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN DBMS_STATS.gather_schema_stats(''SCOTT'', ESTIMATE_PERCENT => 33, CASCADE => TRUE); END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'freq=daily; byhour=12; byminute=40',
    end_date        => NULL,
    enabled         => TRUE,
    comments        => 'Job defined entirely by the CREATE JOB procedure.');
END;
/

SELECT OWNER||'.'||TABLE_NAME TBL,BLOCKS,LAST_ANALYZED FROM DBA_TABLES WHERE OWNER='&USER' ORDER BY 3 NULLS FIRST;

BEGIN
  -- Job defined entirely by the CREATE JOB procedure.
  DBMS_SCHEDULER.create_job (
    job_name        => 'Gather_MANDIRIMAIN',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN DBMS_STATS.GATHER_SCHEMA_STATS(''MANDIRIMAIN'', ESTIMATE_PERCENT => 33, CASCADE => TRUE); END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'freq=daily; byhour=20; byminute=40',
    end_date        => NULL,
    enabled         => TRUE,
    comments        => 'Prosedur scheduler job analyze skema MANDIRIMAIN.');
END;
/

EXEC DBMS_STATS.GATHER_TABLE_STATS('SCOTT', 'EMPLOYEES', ESTIMATE_PERCENT => 15, CASCADE => TRUE);

BEGIN
  -- Job defined entirely by the CREATE JOB procedure.
  DBMS_SCHEDULER.create_job (
    job_name        => 'ANALYZE_MANDIRIMAIN_TEST',
    job_type        => 'PLSQL_BLOCK',
    job_action      => '
	BEGIN
	DBMS_STATS.GATHER_TABLE_STATS(''MANDIRIMAIN'', ''ZTIME'', ESTIMATE_PERCENT => 33, CASCADE => TRUE);
	DBMS_STATS.GATHER_TABLE_STATS(''MANDIRIMAIN'', ''ZIPCODE_REGION_MAP'', ESTIMATE_PERCENT => 33, CASCADE => TRUE);
	DBMS_STATS.GATHER_TABLE_STATS(''MANDIRIMAIN'', ''XX1'', ESTIMATE_PERCENT => 33, CASCADE => TRUE);
	DBMS_STATS.GATHER_TABLE_STATS(''MANDIRIMAIN'', ''ZZ'', ESTIMATE_PERCENT => 33, CASCADE => TRUE);
	END;',
	start_date      => SYSTIMESTAMP,
    repeat_interval => 'freq=daily; byhour=21; byminute=00',
    end_date        => NULL,
    enabled         => TRUE,
    comments        => 'Prosedur scheduler job analyze TABLE MANDIRIMAIN.');
END;
/

SELECT * FROM DBA_SCHEDULER_JOBS WHERE OWNER='SYSTEM';
EXEC DBMS_SCHEDULER.DROP_JOB('SYSTEM.GATHER_SCHEMAMANDIRIMAIN_STATS');
EXEC DBMS_SCHEDULER.DROP_JOB('SYS.ANALYZE_MANDIRIMAIN_TEST');
EXEC DBMS_SCHEDULER.DROP_JOB('SYS.GATHER_MANDIRIMAIN');
SELECT * FROM DBA_SCHEDULER_JOBS WHERE OWNER='SYS' AND JOB_NAME='GATHER_MANDIRIMAIN';

SELECT
'EXEC DBMS_STATS.GATHER_TABLE_STATS('''||OWNER||''', '''||TABLE_NAME||''', ESTIMATE_PERCENT => 33, CASCADE => TRUE);'
GATH_TABLE FROM DBA_TABLES WHERE OWNER='MANDIRIMAIN' ORDER BY 1;