nano /home/orekel/arc.rman
---------------------------------------
run
{
  allocate channel dbbackup1 type disk;
  allocate channel dbbackup2 type disk;
  allocate channel dbbackup3 type disk;
  allocate channel dbbackup4 type disk;
  allocate channel dbbackup5 type disk;
  allocate channel dbbackup6 type disk;
  allocate channel dbbackup7 type disk;
  allocate channel dbbackup8 type disk;
  sql 'alter system archive log current';
  backup as compressed backupset archivelog FROM TIME 'TRUNC(SYSDATE-1)' tag 'Archivelog' format '/home/orekel/backup/arcdaily/ARCH_%I_%d_%s_%p_%T';
  release channel dbbackup1;
  release channel dbbackup2;
  release channel dbbackup3;
  release channel dbbackup4;
  release channel dbbackup5;
  release channel dbbackup6;
  release channel dbbackup7;
  release channel dbbackup8;
  CROSSCHECK ARCHIVELOG ALL;
  DELETE NOPROMPT EXPIRED BACKUP;
  DELETE NOPROMPT EXPIRED ARCHIVELOG ALL;
}

nano /home/orekel/arc.sh
-------------------------------------
source /home/orekel/.bash_profile
/u01/app/orekel/product/11.2.0.4/db_1/bin/rman target=/ cmdfile='/home/orekel/arc.rman' log=/home/orekel/arc_`date +%Y%m%d`.log

--Bikin program
BEGIN
  DBMS_SCHEDULER.create_program
  (
    program_name        => 'PROGBACKUPARC',
    program_type        => 'EXECUTABLE',
    program_action      => '/home/orekel/arc.sh',
    number_of_arguments => 0,
    enabled             => TRUE,
    comments            => 'Program to backup archivelog by AzizPW shell script.'
  );
END;
/

--Display the program details
SET LINES 150 PAGES 5000 TIMING ON;
COL OWNER FOR A20;
COL PROGRAM_NAME FOR A35;
COL COMMENTS FOR A80;
SELECT OWNER, PROGRAM_NAME, ENABLED, COMMENTS FROM DBA_SCHEDULER_PROGRAMS ORDER BY 1,2;

--Bikin job
BEGIN
  -- Job defined by an existing program and schedule.
  DBMS_SCHEDULER.create_job
  (
    job_name      	=> 'JOBBACKUPARC',
    program_name 	=> 'PROGBACKUPARC',
    start_date		=> SYSTIMESTAMP,
    repeat_interval	=> 'freq=daily; byhour=19; byminute=59',
    end_date        => NULL,
    enabled       	=> TRUE,
    comments      	=> 'Job to execute PROGBACKUPARC by AzizPW'
  );
END;
/

SELECT OWNER||'.'||JOB_NAME JOB_NAME,JOB_CREATOR,STATE,JOB_TYPE,REPEAT_INTERVAL,ENABLED,JOB_ACTION,COMMENTS FROM DBA_SCHEDULER_JOBS WHERE JOB_NAME='JOBBACKUPARC';

--Edit waktu run
BEGIN
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
  (
  	name      => 'JOBBACKUPARC',
  	attribute => 'REPEAT_INTERVAL',
  	value     => 'freq=daily; byhour=20; byminute=33; bysecond=00'
  );
END;
/

--Edit Job_action
BEGIN
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE(
  	name 		=> 'SYSTEM.PROGBACKUPARC',
  	attribute 	=> 'PROGRAM_ACTION',
  	value 		=> '/home/orekel/arc.sh'
  );
END;
/

SET LINES 150 PAGES 5000 TIMING ON ECHO ON;
COL JOBNAME FOR A30;
COL STATUS FOR A10;
COL ACTUAL_START_DATE FOR A35;
COL RUN_DURATION FOR A15;
COL ADDITIONAL_INFO FOR A100;
SELECT OWNER||'.'||JOB_NAME JOBNAME, STATUS, ERROR#, ACTUAL_START_DATE, RUN_DURATION, ADDITIONAL_INFO
FROM DBA_SCHEDULER_JOB_RUN_DETAILS WHERE JOB_NAME='JOBBACKUPARC' ORDER BY ACTUAL_START_DATE DESC;

--Jalankan job
BEGIN
  DBMS_SCHEDULER.RUN_JOB('JOBBACKUPARC');
END;
/
