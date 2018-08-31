ORACLE_SID=DEBITUR; export ORACLE_SID
ORACLE_HOME=/oracle/product/10.2.0; export ORACLE_HOME
BACKUP=/tes; export BACKUP
BACKUPLOG=/tes; export BACKUPLOG
cd $BACKUP
$ORACLE_HOME/bin/rman target=/ cmdfile='/tes/backup.rman' log=$BACKUPLOG/run_backup_`date +%a_H%H`.log

nano /home/orekel/RMAN/script/rman.sh
-------------------------------------
source /home/orekel/.bash_profile; export NLS_DATE_FORMAT='DD-Mon-RR HH24:MI:SS';
$ORACLE_HOME/bin/rman target=/ cmdfile='/home/orekel/RMAN/script/rman.rman' log=/home/orekel/RMAN/backup/rman_`date +%Y%m%d`.log

nano /home/orekel/RMAN/script/rman.rman
---------------------------------------
run {
  ALLOCATE CHANNEL AZZ01 TYPE DISK;
  ALLOCATE CHANNEL AZZ02 TYPE DISK;
  ALLOCATE CHANNEL AZZ03 TYPE DISK;
  ALLOCATE CHANNEL AZZ04 TYPE DISK;
  ALLOCATE CHANNEL AZZ05 TYPE DISK;
  ALLOCATE CHANNEL AZZ06 TYPE DISK;
  ALLOCATE CHANNEL AZZ07 TYPE DISK;
  ALLOCATE CHANNEL AZZ08 TYPE DISK;
  ALLOCATE CHANNEL AZZ09 TYPE DISK;
  ALLOCATE CHANNEL AZZ10 TYPE DISK;
  ALLOCATE CHANNEL AZZ11 TYPE DISK;
  ALLOCATE CHANNEL AZZ12 TYPE DISK;
  BACKUP AS COMPRESSED BACKUPSET SPFILE TAG 'SPFile' FORMAT '/home/orekel/RMAN/backup/SPF_%I%d%T_%s_%p';
  BACKUP AS COMPRESSED BACKUPSET CURRENT CONTROLFILE TAG 'Controlfile' FORMAT '/home/orekel/RMAN/backup/CTRL_%I%d%T_%s_%p';
  BACKUP AS COMPRESSED BACKUPSET CURRENT CONTROLFILE FOR STANDBY TAG 'StbyControl' FORMAT '/home/orekel/RMAN/backup/SBCT_%I%d%T_%s_%p';
  BACKUP AS COMPRESSED BACKUPSET DATABASE TAG 'FULLBACKUP' FORMAT '/home/orekel/RMAN/backup/DB_%I%d%T_%s_%p';
  SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
  BACKUP AS COMPRESSED BACKUPSET ARCHIVELOG ALL DELETE ALL INPUT TAG 'Archivelog' FORMAT '/home/orekel/RMAN/backup/ARC_%I%d%T_%s_%p';
  CROSSCHECK BACKUP;
  DELETE NOPROMPT EXPIRED BACKUP;
  CROSSCHECK ARCHIVELOG ALL;
  DELETE NOPROMPT EXPIRED ARCHIVELOG ALL;
  DELETE NOPROMPT OBSOLETE RECOVERY WINDOW OF 14 DAYS;
  RELEASE CHANNEL AZZ01;
  RELEASE CHANNEL AZZ02;
  RELEASE CHANNEL AZZ03;
  RELEASE CHANNEL AZZ04;
  RELEASE CHANNEL AZZ05;
  RELEASE CHANNEL AZZ06;
  RELEASE CHANNEL AZZ07;
  RELEASE CHANNEL AZZ08;
  RELEASE CHANNEL AZZ09;
  RELEASE CHANNEL AZZ10;
  RELEASE CHANNEL AZZ11;
  RELEASE CHANNEL AZZ12;}

nohup sh /home/orekel/RMAN/script/rman.sh > /home/orekel/RMAN/script/rman_`date +%Y%m%d`.log 2>&1 &

Differential Incremental 1
--------------------------
run{
  ALLOCATE CHANNEL AZZ01 TYPE DISK;
  ALLOCATE CHANNEL AZZ02 TYPE DISK;
  ALLOCATE CHANNEL AZZ03 TYPE DISK;
  ALLOCATE CHANNEL AZZ04 TYPE DISK;
  ALLOCATE CHANNEL AZZ05 TYPE DISK;
  ALLOCATE CHANNEL AZZ06 TYPE DISK;
  ALLOCATE CHANNEL AZZ07 TYPE DISK;
  ALLOCATE CHANNEL AZZ08 TYPE DISK;
  ALLOCATE CHANNEL AZZ09 TYPE DISK;
  ALLOCATE CHANNEL AZZ10 TYPE DISK;
  ALLOCATE CHANNEL AZZ11 TYPE DISK;
  ALLOCATE CHANNEL AZZ12 TYPE DISK;
  BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 1 DATABASE TAG 'Incremental_1' format '/home/orekel/RMAN/backup/INCR1_%I%d%T_%s_%p';
  sql 'alter system archive log current';
  backup as compressed backupset archivelog all delete all input tag 'Archivelog' format '/home/orekel/RMAN/backup/ARCH_%I%d%T_%s_%p';
  CROSSCHECK BACKUP;
  RELEASE CHANNEL AZZ01;
  RELEASE CHANNEL AZZ02;
  RELEASE CHANNEL AZZ03;
  RELEASE CHANNEL AZZ04;
  RELEASE CHANNEL AZZ05;
  RELEASE CHANNEL AZZ06;
  RELEASE CHANNEL AZZ07;
  RELEASE CHANNEL AZZ08;
  RELEASE CHANNEL AZZ09;
  RELEASE CHANNEL AZZ10;
  RELEASE CHANNEL AZZ11;
  RELEASE CHANNEL AZZ12;}

Cumulative Incremental 1
------------------------
run{
  allocate channel dbbackup1 type disk;
  allocate channel dbbackup2 type disk;
  allocate channel dbbackup3 type disk;
  allocate channel dbbackup4 type disk;
  BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 1 CUMULATIVE DATABASE TAG 'Incremental_1' format '/home/orekel/RMAN/backup/INCR1_%I%d%T_%s_%p';
  sql 'alter system archive log current';
  backup as compressed backupset archivelog all delete all input tag 'Archivelog' format '/home/orekel/RMAN/backup/ARCH_%I%d%T_%s_%p';
  release channel dbbackup1;
  release channel dbbackup2;
  release channel dbbackup3;
  release channel dbbackup4;
  CROSSCHECK BACKUP;}

--Change to default
CONFIGURE RETENTION POLICY CLEAR;
configure channel device type sbt parms sbt_library=pathname';
ALLOCATE CHANNEL FOR MAINTENANCE DEVICE TYPE SBT PARMS 'SBT_LIBRARY=/usr/local/oracle/backup/lib/libobk.so, ENV=(OB_DEVICE=oramaster_drive1@mspbackup,OB_MEDIA_FAMILY=RMAN_DEFAULT)';

ALLOCATE CHANNEL CHANN1 DEVICE TYPE sbt PARMS 'SBT_LIBRARY=/usr/local/oracle/backup/lib/libobk.so, ENV=(OB_DEVICE_1=stape2)';