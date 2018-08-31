export NLS_DATE_FORMAT='DD-Mon-RR HH24:MI:SS'; rman target=/
run {
  ALLOCATE CHANNEL AZZ01 TYPE DISK;
  ALLOCATE CHANNEL AZZ02 TYPE DISK;
  BACKUP AS COMPRESSED BACKUPSET SPFILE TAG 'SPFile' FORMAT '/home/orekel/RMAN/backup/SPF_%I_%d_%s_%p_%T';
  BACKUP AS COMPRESSED BACKUPSET CURRENT CONTROLFILE TAG 'Controlfile' FORMAT '/home/orekel/RMAN/backup/CTRL_%I_%d_%s_%p_%T';
  BACKUP AS COMPRESSED BACKUPSET CURRENT CONTROLFILE FOR STANDBY TAG 'StbyControl' FORMAT '/home/orekel/RMAN/backup/SBCT_%I_%d_%s_%p_%T';
  BACKUP AS COMPRESSED BACKUPSET DATABASE TAG 'FULLBACKUP' FORMAT '/home/orekel/RMAN/backup/DB_%I_%d_%s_%p_%T';
  SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
  BACKUP AS COMPRESSED BACKUPSET ARCHIVELOG ALL DELETE ALL INPUT TAG 'Archivelog' FORMAT '/home/orekel/RMAN/backup/ARC_%I_%d_%s_%p_%T';
  CROSSCHECK BACKUP;
  CROSSCHECK ARCHIVELOG ALL;
  RELEASE CHANNEL AZZ01;
  RELEASE CHANNEL AZZ02;
  DELETE NOPROMPT OBSOLETE RECOVERY WINDOW OF 14 DAYS;
  DELETE NOPROMPT EXPIRED BACKUP;}

RESTORE CONTROLFILE FROM '/home/orekel/RMAN/backup/CTRL_1538635403_DUCK_8_1_20180722';
SQL 'ALTER DATABASE MOUNT';
CATALOG START WITH '/home/orekel/RMAN/backup' NOPROMPT;
run {
  ALLOCATE CHANNEL AZZ01 TYPE DISK;
  ALLOCATE CHANNEL AZZ02 TYPE DISK;
  RESTORE DATABASE;
  RECOVER DATABASE;
  RELEASE CHANNEL AZZ01;
  RELEASE CHANNEL AZZ02;}
SQL 'ALTER DATABASE OPEN RESETLOGS';

Backup Restore dan Recover database menggunakan RMAN

RMAN merupakan salah satu metode backup yang disediakan oleh oracle. Sebenarnya ada beberapa metode backup/restore yang disediakan oleh oracle. Tetapi pada kali ini yang akan disimulasikan adalah yang menggunakan RMAN saja.

Skenarionya adalah sebagai berikut:

Insert data ke sebuah tabel sebelum backup
Backup database dan archive log sampai sehari sebelumnya
Merusak database dengan cara menghapus langsung file secara fisikal
Restore kembali database dengan menggunakan file hasil backup
Cek data yang masuk ke dalam tabel.
 

BEFORE
Insert data ke dalam tabel countries;
SQL> Select count(*) from countries;

COUNT(*)

———-

27

SQL> insert into countries values(‘ID’,'Indonesia’,3);

1 row created.

SQL> Select count(*) from countries;

COUNT(*)

———-

28

List datafile,controlfile dan log file
[oracle@host1 ~]$ ls –l /u01/apps/oracle/oradata/orcl

total 1051020

-rw-r—– 1 oracle oinstall 7061504 Mar 21 14:32 control01.ctl

-rw-r—– 1 oracle oinstall 7061504 Mar 21 14:32 control02.ctl

-rw-r—– 1 oracle oinstall 7061504 Mar 21 14:32 control03.ctl

-rw-r—– 1 oracle oinstall 104865792 Mar 21 14:30 example01.dbf

-rw-r—– 1 oracle oinstall 52429312 Mar 21 14:32 redo01.log

-rw-r—– 1 oracle oinstall 52429312 Mar 21 14:30 redo02.log

-rw-r—– 1 oracle oinstall 52429312 Mar 21 14:30 redo03.log

-rw-r—– 1 oracle oinstall 251666432 Mar 21 14:30 sysaux01.dbf

-rw-r—– 1 oracle oinstall 503324672 Mar 21 14:30 system01.dbf

-rw-r—– 1 oracle oinstall 20979712 Dec 12 15:02 temp01.dbf

-rw-r—– 1 oracle oinstall 31465472 Mar 21 14:30 undotbs01.dbf

-rw-r—– 1 oracle oinstall 5251072 Mar 21 14:30 users01.dbf

list archive log file
[oracle@host1 ~]$ ls –l /archivelog

total 7080

-rw-r—– 1 oracle oinstall 5986304 Mar 14 14:28 1_1_737564519.dbf

-rw-r—– 1 oracle oinstall 624128 Dec 12 14:25 1_21_736006903.dbf

-rw-r—– 1 oracle oinstall 1024 Dec 12 14:25 1_22_736006903.dbf

-rw-r—– 1 oracle oinstall 468480 Dec 12 14:35 1_23_736006903.dbf

-rw-r—– 1 oracle oinstall 2048 Dec 12 15:01 1_25_736006903.dbf

-rw-r—– 1 oracle oinstall 19456 Mar 14 14:29 1_2_737564519.dbf

-rw-r—– 1 oracle oinstall 104448 Mar 21 14:30 1_3_737564519.dbf

-rw-r—– 1 oracle oinstall 1536 Mar 21 14:30 1_4_737564519.dbf

BACKUP
Backup full database beserta dengan archive log 1 hari terakhir dan juga controlfile
[oracle@host1 ~]$ rman target /

Recovery Manager: Release 10.2.0.1.0 – Production on Sun Dec 12 15:07:44 2010

 

Copyright (c) 1982, 2005, Oracle. All rights reserved.

 

connected to target database: orcl (DBID=4073141093)

 

RMAN> run{

2> allocate channel cdisk type disk;

3> backup database format ‘/backup/database_%s.dbf’;

4> sql ‘alter system switch logfile’;

5> backup archivelog from time ‘sysdate-1′ format ‘/backup/archive_%s.dbf’;

6> backup current controlfile format ‘/backup/ctlfile_%s.ctl’;

7> release channel cdisk;

8> }

 

using target database control file instead of recovery catalog

allocated channel: cdisk

channel cdisk: sid=139 devtype=DISK

 

Starting backup at 21-MAR-11

channel cdisk: starting full datafile backupset

channel cdisk: specifying datafile(s) in backupset

input datafile fno=00001 name=/u01/app/oracle/oradata/orcl/system01.dbf

input datafile fno=00003 name=/u01/app/oracle/oradata/orcl/sysaux01.dbf

input datafile fno=00005 name=/u01/app/oracle/oradata/orcl/example01.dbf

input datafile fno=00002 name=/u01/app/oracle/oradata/orcl/undotbs01.dbf

input datafile fno=00004 name=/u01/app/oracle/oradata/orcl/users01.dbf

channel cdisk: starting piece 1 at 21-MAR-11

channel cdisk: finished piece 1 at 21-MAR-11

piece handle=/backup/database_5.dbf tag=TAG20110321T143347 comment=NONE

channel cdisk: backup set complete, elapsed time: 00:01:05

channel cdisk: starting full datafile backupset

channel cdisk: specifying datafile(s) in backupset

including current control file in backupset

including current SPFILE in backupset

channel cdisk: starting piece 1 at 21-MAR-11

channel cdisk: finished piece 1 at 21-MAR-11

piece handle=/backup/database_6.dbf tag=TAG20110321T143347 comment=NONE

channel cdisk: backup set complete, elapsed time: 00:00:03

Finished backup at 21-MAR-11

 

sql statement: alter system switch logfile

 

Starting backup at 21-MAR-11

current log archived

channel cdisk: starting archive log backupset

channel cdisk: specifying archive log(s) in backup set

input archive log thread=1 sequence=3 recid=28 stamp=746375434

input archive log thread=1 sequence=4 recid=29 stamp=746375445

input archive log thread=1 sequence=5 recid=30 stamp=746375697

input archive log thread=1 sequence=6 recid=31 stamp=746375697

channel cdisk: starting piece 1 at 21-MAR-11

channel cdisk: finished piece 1 at 21-MAR-11

piece handle=/backup/archive_7.dbf tag=TAG20110321T143457 comment=NONE

channel cdisk: backup set complete, elapsed time: 00:00:02

Finished backup at 21-MAR-11

 

Starting backup at 21-MAR-11

channel cdisk: starting full datafile backupset

channel cdisk: specifying datafile(s) in backupset

including current control file in backupset

channel cdisk: starting piece 1 at 21-MAR-11

channel cdisk: finished piece 1 at 21-MAR-11

piece handle=/backup/ctlfile_8.ctl tag=TAG20110321T143500 comment=NONE

channel cdisk: backup set complete, elapsed time: 00:00:01

Finished backup at 21-MAR-11

 

released channel: cdisk

 

Verifikasi hasil backup
Dari sisi Operating System
[oracle@host1 backup]$ ls -l /backup

total 616652

-rw-r—– 1 oracle oinstall 1005056 Mar 21 14:34 archive_7.dbf

-rw-r—– 1 oracle oinstall 7110656 Mar 21 14:35 ctlfile_8.ctl

-rw-r—– 1 oracle oinstall 615555072 Mar 21 14:34 database_5.dbf

-rw-r—– 1 oracle oinstall 7143424 Mar 21 14:34 database_6.dbf

 

Dari sisi RMAN
RMAN> list backup;

BS Key Type LV Size Device Type Elapsed Time Completion Time

——- —- — ———- ———– ———— —————

5 Full 587.03M DISK 00:00:59 21-MAR-11

BP Key: 5 Status: AVAILABLE Compressed: NO Tag: TAG20110321T143347

Piece Name: /backup/database_5.dbf

List of Datafiles in backup set 5

File LV Type Ckp SCN Ckp Time Name

—- — —- ———- ——— —-

1 Full 570332 21-MAR-11 /u01/app/oracle/oradata/orcl/system01.dbf

2 Full 570332 21-MAR-11 /u01/app/oracle/oradata/orcl/undotbs01.dbf

3 Full 570332 21-MAR-11 /u01/app/oracle/oradata/orcl/sysaux01.dbf

4 Full 570332 21-MAR-11 /u01/app/oracle/oradata/orcl/users01.dbf

5 Full 570332 21-MAR-11 /u01/app/oracle/oradata/orcl/example01.dbf

 

BS Key Type LV Size Device Type Elapsed Time Completion Time

——- —- — ———- ———– ———— —————

6 Full 6.80M DISK 00:00:03 21-MAR-11

BP Key: 6 Status: AVAILABLE Compressed: NO Tag: TAG20110321T143347

Piece Name: /backup/database_6.dbf

Control File Included: Ckp SCN: 570349 Ckp time: 21-MAR-11

SPFILE Included: Modification time: 12-DEC-10

 

BS Key Size Device Type Elapsed Time Completion Time

——- ———- ———– ———— —————

7 981.00K DISK 00:00:02 21-MAR-11

BP Key: 7 Status: AVAILABLE Compressed: NO Tag: TAG20110321T143457

Piece Name: /backup/archive_7.dbf

 

List of Archived Logs in backup set 7

Thrd Seq Low SCN Low Time Next SCN Next Time

—- ——- ———- ——— ———- ———

1 3 569656 14-MAR-11 569733 21-MAR-11

1 4 569733 21-MAR-11 569738 21-MAR-11

1 5 569738 21-MAR-11 570360 21-MAR-11

1 6 570360 21-MAR-11 570365 21-MAR-11

 

BS Key Type LV Size Device Type Elapsed Time Completion Time

——- —- — ———- ———– ———— —————

8 Full 6.77M DISK 00:00:01 21-MAR-11

BP Key: 8 Status: AVAILABLE Compressed: NO Tag: TAG20110321T143500

Piece Name: /backup/ctlfile_8.ctl

Control File Included: Ckp SCN: 570371 Ckp time: 21-MAR-11

 

Pengecekan resource yang sudah obsolete
RMAN> report obsolete;

 

RMAN retention policy will be applied to the command

RMAN retention policy is set to redundancy 1

Report of obsolete backups and copies

Type Key Completion Time Filename/Handle

——————– —— —————— ——————–

Backup Set 1 12-DEC-10

Backup Piece 1 12-DEC-10 /backup/database_1.dbf

Archive Log 22 12-DEC-10 /archivelog/1_21_736006903.dbf

Backup Set 2 12-DEC-10

Backup Piece 2 12-DEC-10 /backup/database_2.dbf

Archive Log 23 12-DEC-10 /archivelog/1_22_736006903.dbf

Backup Set 3 12-DEC-10

Backup Piece 3 12-DEC-10 /backup/archive_3.dbf

Archive Log 24 12-DEC-10 /archivelog/1_23_736006903.dbf

Backup Set 4 12-DEC-10

Backup Piece 4 12-DEC-10 /backup/ctlfile_4.ctl

Archive Log 25 12-DEC-10 /archivelog/1_25_736006903.dbf

Archive Log 26 14-MAR-11 /archivelog/1_1_737564519.dbf

Archive Log 27 14-MAR-11 /archivelog/1_2_737564519.dbf

Archive Log 28 21-MAR-11 /archivelog/1_3_737564519.dbf

Archive Log 29 21-MAR-11 /archivelog/1_4_737564519.dbf

 

Menghapus resource yang sudah obsolete
RMAN> delete obsolete;

 

RMAN retention policy will be applied to the command

RMAN retention policy is set to redundancy 1

allocated channel: ORA_DISK_1

channel ORA_DISK_1: sid=139 devtype=DISK

Deleting the following obsolete backups and copies:

Type Key Completion Time Filename/Handle

——————– —— —————— ——————–

Backup Set 1 12-DEC-10

Backup Piece 1 12-DEC-10 /backup/database_1.dbf

Archive Log 22 12-DEC-10 /archivelog/1_21_736006903.dbf

Backup Set 2 12-DEC-10

Backup Piece 2 12-DEC-10 /backup/database_2.dbf

Archive Log 23 12-DEC-10 /archivelog/1_22_736006903.dbf

Backup Set 3 12-DEC-10

Backup Piece 3 12-DEC-10 /backup/archive_3.dbf

Archive Log 24 12-DEC-10 /archivelog/1_23_736006903.dbf

Backup Set 4 12-DEC-10

Backup Piece 4 12-DEC-10 /backup/ctlfile_4.ctl

Archive Log 25 12-DEC-10 /archivelog/1_25_736006903.dbf

Archive Log 26 14-MAR-11 /archivelog/1_1_737564519.dbf

Archive Log 27 14-MAR-11 /archivelog/1_2_737564519.dbf

Archive Log 28 21-MAR-11 /archivelog/1_3_737564519.dbf

Archive Log 29 21-MAR-11 /archivelog/1_4_737564519.dbf

 

Do you really want to delete the above objects (enter YES or NO)? yes

deleted archive log

archive log filename=/archivelog/1_21_736006903.dbf recid=22 stamp=737562356

deleted archive log

archive log filename=/archivelog/1_22_736006903.dbf recid=23 stamp=737562357

deleted archive log

archive log filename=/archivelog/1_23_736006903.dbf recid=24 stamp=737562939

deleted archive log

archive log filename=/archivelog/1_25_736006903.dbf recid=25 stamp=737564519

deleted archive log

archive log filename=/archivelog/1_1_737564519.dbf recid=26 stamp=745770529

deleted archive log

archive log filename=/archivelog/1_2_737564519.dbf recid=27 stamp=745770582

deleted archive log

archive log filename=/archivelog/1_3_737564519.dbf recid=28 stamp=746375434

deleted archive log

archive log filename=/archivelog/1_4_737564519.dbf recid=29 stamp=746375445

Deleted 8 objects

 

RMAN> report obsolete;

 

RMAN retention policy will be applied to the command

RMAN retention policy is set to redundancy 1

no obsolete backups found

 

Cek sisa file yang tidak dihapus di Operating System
[oracle@host1 archive]$ ls -l

total 888

-rw-r—– 1 oracle oinstall 898048 Mar 21 14:34 1_5_737564519.dbf

-rw-r—– 1 oracle oinstall 1024 Mar 21 14:34 1_6_737564519.dbf

 

Skenario: menghapus physical file dari Operating System
Menghapus datafile,controlfile dan logfile dari level OS
[oracle@host1 orcl]$ rm redo02.log

[oracle@host1 orcl]$ rm sysaux01.dbf

[oracle@host1 orcl]$ rm system01.dbf

[oracle@host1 orcl]$ rm users01.dbf

[oracle@host1 orcl]$ rm example01.dbf

[oracle@host1 orcl]$ rm control01.ctl

[oracle@host1 orcl]$ ls -l

total 147176

-rw-r—– 1 oracle oinstall 7061504 Mar 21 14:43 control02.ctl

-rw-r—– 1 oracle oinstall 7061504 Mar 21 14:43 control03.ctl

-rw-r—– 1 oracle oinstall 52429312 Mar 21 14:34 redo01.log

-rw-r—– 1 oracle oinstall 52429312 Mar 21 14:43 redo03.log

-rw-r—– 1 oracle oinstall 20979712 Dec 12 15:02 temp01.dbf

-rw-r—– 1 oracle oinstall 31465472 Mar 21 14:42 undotbs01.dbf

 

Mencoba mematikan dan menyalakan database sesudah dirusak
[oracle@host1 archive]$ sqlplus / as sysdba;

 

SQL*Plus: Release 10.2.0.1.0 – Production on Mon Mar 21 14:44:11 2011

 

Copyright (c) 1982, 2005, Oracle. All rights reserved.

 

 

Connected to:

Oracle Database 10g Enterprise Edition Release 10.2.0.1.0 – Production

With the Partitioning, OLAP and Data Mining options

 

SQL> shutdown immediate;

ORA-00210: cannot open the specified control file

ORA-00202: control file: ‘/u01/app/oracle/oradata/orcl/control01.ctl’

ORA-27041: unable to open file

Linux Error: 2: No such file or directory

Additional information: 3

SQL> shutdown abort;

ORACLE instance shut down.

 

SQL> startup;

ORACLE instance started.

 

Total System Global Area 218103808 bytes

Fixed Size 1218580 bytes

Variable Size 75499500 bytes

Database Buffers 134217728 bytes

Redo Buffers 7168000 bytes

ORA-00205: error in identifying control file, check alert log for more info

 

SQL> select status from v$instance;

 

STATUS

————

STARTED

 

Restore dan Recover
Untuk menyelamatkan database, kita akan mencoba restore dan recover database dengan menggunakan backup yang ada.

Restore controlfile dari backup
RMAN> restore controlfile from ‘/backup/ctlfile_8.ctl’;

 

Starting restore at 21-MAR-11

using channel ORA_DISK_1

 

channel ORA_DISK_1: restoring control file

channel ORA_DISK_1: restore complete, elapsed time: 00:00:04

output filename=/u01/app/oracle/oradata/orcl/control01.ctl

output filename=/u01/app/oracle/oradata/orcl/control02.ctl

output filename=/u01/app/oracle/oradata/orcl/control03.ctl

Finished restore at 21-MAR-11

 

Mount database
SQL> alter database mount;

 

Database altered.

 

Restore database
RMAN> restore database;

 

Starting restore at 21-MAR-11

released channel: ORA_DISK_1

Starting implicit crosscheck backup at 21-MAR-11

allocated channel: ORA_DISK_1

channel ORA_DISK_1: sid=155 devtype=DISK

Crosschecked 7 objects

Finished implicit crosscheck backup at 21-MAR-11

 

Starting implicit crosscheck copy at 21-MAR-11

using channel ORA_DISK_1

Finished implicit crosscheck copy at 21-MAR-11

 

searching for all files in the recovery area

cataloging files…

no files cataloged

 

using channel ORA_DISK_1

 

channel ORA_DISK_1: starting datafile backupset restore

channel ORA_DISK_1: specifying datafile(s) to restore from backup set

restoring datafile 00001 to /u01/app/oracle/oradata/orcl/system01.dbf

restoring datafile 00002 to /u01/app/oracle/oradata/orcl/undotbs01.dbf

restoring datafile 00003 to /u01/app/oracle/oradata/orcl/sysaux01.dbf

restoring datafile 00004 to /u01/app/oracle/oradata/orcl/users01.dbf

restoring datafile 00005 to /u01/app/oracle/oradata/orcl/example01.dbf

channel ORA_DISK_1: reading from backup piece /backup/database_5.dbf

channel ORA_DISK_1: restored backup piece 1

piece handle=/backup/database_5.dbf tag=TAG20110321T143347

channel ORA_DISK_1: restore complete, elapsed time: 00:00:55

Finished restore at 21-MAR-11

 

Recover Database
RMAN> recover database;

 

Starting recover at 21-MAR-11

using channel ORA_DISK_1

 

starting media recovery

 

archive log thread 1 sequence 5 is already on disk as file /u01/app/oracle/oradata/orcl/redo01.log

archive log thread 1 sequence 6 is already on disk as file /archivelog/1_6_737564519.dbf

archive log thread 1 sequence 7 is already on disk as file /u01/app/oracle/oradata/orcl/redo03.log

archive log filename=/u01/app/oracle/oradata/orcl/redo01.log thread=1 sequence=5

archive log filename=/archivelog/1_6_737564519.dbf thread=1 sequence=6

archive log filename=/u01/app/oracle/oradata/orcl/redo03.log thread=1 sequence=7

media recovery complete, elapsed time: 00:00:04

Finished recover at 21-MAR-11

 

Open database dengan opsi resetlogs
SQL> alter database open resetlogs;

 

Database altered.

 

Cek hasil restore
SQL> select status from v$instance;

 

STATUS

————

OPEN

 

SQL> Select count(*) from countries;

COUNT(*)

———-

28


select sum(bytes)/1024/1024/1024 SizeGB from dba_data_files;

select * from v$version;

select * from dba_data_files;

select * from v$asm_diskgroup;