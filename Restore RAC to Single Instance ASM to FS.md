STEP BY STEP RESTORE DATABASE MGW (RAC) KE SINGLE INSTANCE RHEL ENVIRONMENT
1. PREPARE OS RHEL dan INSTALL ORACLE 11.2.0.2

2. CREATE PFILE FOR SINGLE FROM PFILE RAC
initmgw1.ora (RAC)
mgw2.__db_cache_size=452984832
mgw1.__db_cache_size=553648128
mgw2.__java_pool_size=16777216
mgw1.__java_pool_size=16777216
mgw1.__large_pool_size=16777216
mgw2.__large_pool_size=33554432
mgw1.__oracle_base='/oracle/app/oracle'#ORACLE_BASE set from environment
mgw2.__oracle_base='/oracle/app/oracle'#ORACLE_BASE set from environment
mgw1.__pga_aggregate_target=603979776
mgw2.__pga_aggregate_target=553648128
mgw1.__sga_target=1543503872
mgw2.__sga_target=1593835520
mgw1.__shared_io_pool_size=0
mgw2.__shared_io_pool_size=117440512
mgw2.__shared_pool_size=922746880
mgw1.__shared_pool_size=905969664
mgw1.__streams_pool_size=16777216
mgw2.__streams_pool_size=16777216
*.audit_file_dest='/oracle/app/oracle/admin/mgw/adump'
*.audit_trail='db'
*.cluster_database=true
*.compatible='11.2.0.0.0'
*.control_files='+CMSMGWDATA/mgw/controlfile/current.260.739189725'
*.db_block_size=8192
*.db_create_file_dest='+CMSMGWDATA'
*.db_domain=''
*.db_name='mgw'
*.diagnostic_dest='/oracle/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=mgwXDB)'
mgw1.instance_number=1
mgw2.instance_number=2
*.listener_networks='((name=OAM_NETWORK)(local_listener=LISTENER_OAM_LOCAL)(remote_listener=LISTENER_OAM_REMOTE))'
*.log_archive_dest_1='LOCATION=+CMSMGWARCHDISK'
*.memory_target=2147483648
*.open_cursors=1000
*.processes=1000
*.remote_listener='sadb-cluster-scan:1521'
*.remote_login_passwordfile='exclusive'
*.session_cached_cursors=300
*.sessions=1000
mgw2.thread=2
mgw1.thread=1
mgw2.undo_tablespace='UNDOTBS2'
mgw1.undo_tablespace='UNDOTBS1'


initmgw.ora (SINGLE)
mgw.__db_cache_size=553648128
mgw.__java_pool_size=16777216
mgw.__large_pool_size=16777216
mgw.__oracle_base='/oracle/app/oracle'#ORACLE_BASE set from environment
mgw.__pga_aggregate_target=603979776
mgw.__sga_target=1543503872
mgw.__shared_io_pool_size=0
mgw.__shared_pool_size=905969664
mgw.__streams_pool_size=16777216
*.audit_file_dest='/u01/app/oracle/admin/mgw/adump'
*.audit_trail='db'
*.compatible='11.2.0.0.0'
*.control_files='/u01/app/oracle/oradata/mgw/control01.ctl'
*.db_block_size=8192
*.db_file_name_convert='+DATA/orcl/onlinelog/','/u01/app/oracle/oradata/mgw/'
*.db_create_online_log_dest_1=’ /u01/app/oracle/oradata/'
*.db_domain=''
*.db_name='mgw'
*.db_recovery_file_dest='/u01/app/oracle/flash_recovery_area'
*.db_recovery_file_dest_size=4G
*.diagnostic_dest='/u01/app/oracle'
*.memory_target=2147483648
*.open_cursors=1000
*.processes=1000
*.remote_login_passwordfile='exclusive'
*.session_cached_cursors=300
*.sessions=1000



startup nomount dan restore controlfile
create directory for audit dump
[oracle@nicole ~]$ mkdir -p /u01/app/oracle/admin/mgw/adump/

create pfile for single (file pfile terlampir)
[oracle@nicole ~]$ vi $ORACLE_HOME/dbs/initmgw.ora

startup nomount
[oracle@nicole ~]$ sqlplus / as sysdba
SQL> startup nomount

restore controlfile
[oracle@nicole ~]$ mkdir -p /u01/app/backupset

[oracle@nicole ~]$ rman target /

Recovery Manager: Release 11.2.0.2.0 - Production on Fri Jul 25 19:54:57 2014

Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.

connected to target database: MGW (not mounted)

RMAN> restore controlfile from '/u01/app/backupset/ctrl_mgw1_7291_1_851829559';

Starting restore at 25-JUL-2014 19:55:01
using target database control file instead of recovery catalog
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=19 device type=DISK

channel ORA_DISK_1: restoring control file
channel ORA_DISK_1: restore complete, elapsed time: 00:00:04
output file name=/u01/app/oracle/oradata/mgw/control01.ctl
Finished restore at 25-JUL-2014 19:55:05

RMAN> exit


Recovery Manager complete.



MOUNT DATABASE
[oracle@nicole ~]$ sqlplus / as sysdba

SQL*Plus: Release 11.2.0.2.0 Production on Fri Jul 25 19:55:44 2014

Copyright (c) 1982, 2010, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.2.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

SQL> alter database mount;

Database altered.

SQL> show parameter control

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
control_file_record_keep_time	     integer	 7
control_files			     string	 /u01/app/oracle/oradata/mgw/co
						 ntrol01.ctl
control_management_pack_access	     string	 DIAGNOSTIC+TUNING

CATALOGING BACKUPSET
copy file backupset ke directory /u01/app/backupset

[oracle@nicole backupset]$ rman target /

Recovery Manager: Release 11.2.0.2.0 - Production on Fri Jul 25 19:58:19 2014

Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.

connected to target database: MGW (DBID=2176662940, not open)

RMAN> catalog start with '/u01/app/backupset/';       

Starting implicit crosscheck backup at 25-JUL-2014 19:59:05
using target database control file instead of recovery catalog
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=21 device type=DISK
Crosschecked 1000 objects
Finished implicit crosscheck backup at 25-JUL-2014 19:59:09

Starting implicit crosscheck copy at 25-JUL-2014 19:59:09
using channel ORA_DISK_1
Finished implicit crosscheck copy at 25-JUL-2014 19:59:09

searching for all files in the recovery area
cataloging files...
no files cataloged

searching for all files that match the pattern /u01/app/backupset/

List of Files Unknown to the Database
=====================================
File Name: /u01/app/backupset/arc_mgw1_7289_1_851829138
File Name: /u01/app/backupset/fullbk_mgw1_7285_1_851828562
File Name: /u01/app/backupset/fullbk_mgw1_7287_1_851828770
File Name: /u01/app/backupset/fullbk_mgw1_7286_1_851828727
File Name: /u01/app/backupset/ctrl_mgw1_7291_1_851829559
File Name: /u01/app/backupset/arc_mgw1_7288_1_851829097
File Name: /u01/app/backupset/arc_mgw1_7290_1_851829269
File Name: /u01/app/backupset/fullbk_mgw1_7284_1_851828556

Do you really want to catalog the above files (enter YES or NO)? yes
cataloging files...
cataloging done

List of Cataloged Files
=======================
File Name: /u01/app/backupset/arc_mgw1_7289_1_851829138
File Name: /u01/app/backupset/fullbk_mgw1_7285_1_851828562
File Name: /u01/app/backupset/fullbk_mgw1_7287_1_851828770
File Name: /u01/app/backupset/fullbk_mgw1_7286_1_851828727
File Name: /u01/app/backupset/ctrl_mgw1_7291_1_851829559
File Name: /u01/app/backupset/arc_mgw1_7288_1_851829097
File Name: /u01/app/backupset/arc_mgw1_7290_1_851829269
File Name: /u01/app/backupset/fullbk_mgw1_7284_1_851828556

RMAN> list backup summary;


List of Backups
===============
Key     TY LV S Device Type Completion Time      #Pieces #Copies Compressed Tag
------- -- -- - ----------- -------------------- ------- ------- ---------- ---
6250    B  F  X DISK        16-JAN-2014 03:06:27 1       1       NO         TAG20140116T030605
6254    B  F  X DISK        17-JAN-2014 03:06:01 1       1       NO         TAG20140117T030540
6290    B  F  X DISK        18-JAN-2014 03:35:00 1       1       NO         TAG20140118T033449
6295    B  F  X DISK        19-JAN-2014 03:04:10 1       1       NO         TAG20140119T030408
6300    B  F  X DISK        20-JAN-2014 03:04:31 1       1       NO         TAG20140120T030412
6304    B  F  X DISK        21-JAN-2014 03:06:45 1       1       NO         TAG20140121T030622
6305    B  0  X DISK        22-JAN-2014 03:03:18 1       1       NO         HOT_DB_BK_LEVEL0
6306    B  0  X DISK        22-JAN-2014 03:03:44 1       1       NO         HOT_DB_BK_LEVEL0
6307    B  0  X DISK        22-JAN-2014 03:03:51 1       1       NO         HOT_DB_BK_LEVEL0
6308    B  0  X DISK        22-JAN-2014 03:04:50 1       1       NO         HOT_DB_BK_LEVEL0
6313    B  F  X DISK        22-JAN-2014 03:08:43 1       1       NO         TAG20140122T030833
6318    B  F  X DISK        23-JAN-2014 03:15:23 1       1       NO         TAG20140123T031431
6322    B  F  X DISK        24-JAN-2014 03:04:45 1       1       NO         TAG20140124T030425
6327    B  F  X DISK        25-JAN-2014 03:05:24 1       1       NO         TAG20140125T030512
6332    B  F  X DISK        26-JAN-2014 03:05:39 1       1       NO         TAG20140126T030519
6337    B  F  X DISK        27-JAN-2014 03:04:50 1       1       NO         TAG20140127T030438
6342    B  F  X DISK        28-JAN-2014 03:07:55 1       1       NO         TAG20140128T030732
6343    B  0  X DISK        29-JAN-2014 03:02:42 1       1       NO         HOT_DB_BK_LEVEL0
6344    B  0  X DISK        29-JAN-2014 03:03:11 1       1       NO         HOT_DB_BK_LEVEL0
6345    B  0  X DISK        29-JAN-2014 03:03:19 1       1       NO         HOT_DB_BK_LEVEL0
6346    B  0  X DISK        29-JAN-2014 03:03:47 1       1       NO         HOT_DB_BK_LEVEL0
6351    B  F  X DISK        29-JAN-2014 03:07:52 1       1       NO         TAG20140129T030742
6357    B  F  X DISK        30-JAN-2014 03:06:49 1       1       NO         TAG20140130T030630
6361    B  F  X DISK        31-JAN-2014 03:04:39 1       1       NO         TAG20140131T030421
6366    B  F  X DISK        01-FEB-2014 03:05:32 1       1       NO         TAG20140201T030512
6371    B  F  X DISK        02-FEB-2014 03:05:44 1       1       NO         TAG20140202T030523
6376    B  F  X DISK        03-FEB-2014 03:05:30 1       1       NO         TAG20140203T030519
6381    B  F  X DISK        04-FEB-2014 03:08:51 1       1       NO         TAG20140204T030827
6382    B  0  X DISK        05-FEB-2014 03:02:44 1       1       NO         HOT_DB_BK_LEVEL0
6383    B  0  X DISK        05-FEB-2014 03:03:12 1       1       NO         HOT_DB_BK_LEVEL0
6384    B  0  X DISK        05-FEB-2014 03:03:17 1       1       NO         HOT_DB_BK_LEVEL0
6385    B  0  X DISK        05-FEB-2014 03:03:55 1       1       NO         HOT_DB_BK_LEVEL0
6390    B  F  X DISK        05-FEB-2014 03:09:02 1       1       NO         TAG20140205T030842
6395    B  F  X DISK        06-FEB-2014 03:05:57 1       1       NO         TAG20140206T030535
6400    B  F  X DISK        07-FEB-2014 03:05:17 1       1       NO         TAG20140207T030459
6405    B  F  X DISK        08-FEB-2014 03:05:18 1       1       NO         TAG20140208T030506
6410    B  F  X DISK        09-FEB-2014 03:05:40 1       1       NO         TAG20140209T030518
6415    B  F  X DISK        10-FEB-2014 03:05:37 1       1       NO         TAG20140210T030518
6420    B  F  X DISK        11-FEB-2014 03:08:45 1       1       NO         TAG20140211T030823
6421    B  0  X DISK        12-FEB-2014 03:02:49 1       1       NO         HOT_DB_BK_LEVEL0
6422    B  0  X DISK        12-FEB-2014 03:03:13 1       1       NO         HOT_DB_BK_LEVEL0
6423    B  0  X DISK        12-FEB-2014 03:03:17 1       1       NO         HOT_DB_BK_LEVEL0
6424    B  0  X DISK        12-FEB-2014 03:03:58 1       1       NO         HOT_DB_BK_LEVEL0
6429    B  F  X DISK        12-FEB-2014 03:08:49 1       1       NO         TAG20140212T030839
6434    B  F  X DISK        13-FEB-2014 03:05:29 1       1       NO         TAG20140213T030515
6439    B  F  X DISK        14-FEB-2014 03:09:45 1       1       NO         TAG20140214T030923
6444    B  F  X DISK        15-FEB-2014 03:06:30 1       1       NO         TAG20140215T030608
6449    B  F  X DISK        16-FEB-2014 03:05:49 1       1       NO         TAG20140216T030531
6454    B  F  X DISK        17-FEB-2014 03:05:32 1       1       NO         TAG20140217T030511
6459    B  F  X DISK        18-FEB-2014 03:09:34 1       1       NO         TAG20140218T030900
6460    B  0  X DISK        19-FEB-2014 03:02:47 1       1       NO         HOT_DB_BK_LEVEL0
6461    B  0  X DISK        19-FEB-2014 03:03:15 1       1       NO         HOT_DB_BK_LEVEL0
6462    B  0  X DISK        19-FEB-2014 03:03:22 1       1       NO         HOT_DB_BK_LEVEL0
6463    B  0  X DISK        19-FEB-2014 03:04:01 1       1       NO         HOT_DB_BK_LEVEL0
6468    B  F  X DISK        19-FEB-2014 03:09:05 1       1       NO         TAG20140219T030847
6473    B  F  X DISK        20-FEB-2014 03:06:48 1       1       NO         TAG20140220T030628
6478    B  F  X DISK        21-FEB-2014 03:05:04 1       1       NO         TAG20140221T030446
6483    B  F  X DISK        22-FEB-2014 03:05:12 1       1       NO         TAG20140222T030453
6488    B  F  X DISK        23-FEB-2014 03:05:53 1       1       NO         TAG20140223T030532
6493    B  F  X DISK        24-FEB-2014 03:05:50 1       1       NO         TAG20140224T030527
6498    B  F  X DISK        25-FEB-2014 03:08:25 1       1       NO         TAG20140225T030803
6499    B  0  X DISK        26-FEB-2014 03:02:59 1       1       NO         HOT_DB_BK_LEVEL0
6500    B  0  X DISK        26-FEB-2014 03:03:25 1       1       NO         HOT_DB_BK_LEVEL0
6501    B  0  X DISK        26-FEB-2014 03:03:31 1       1       NO         HOT_DB_BK_LEVEL0
6502    B  0  X DISK        26-FEB-2014 03:04:21 1       1       NO         HOT_DB_BK_LEVEL0
6507    B  F  X DISK        26-FEB-2014 03:08:58 1       1       NO         TAG20140226T030837
6512    B  F  X DISK        27-FEB-2014 03:06:06 1       1       NO         TAG20140227T030548
6517    B  F  X DISK        28-FEB-2014 03:06:07 1       1       NO         TAG20140228T030548
6522    B  F  X DISK        01-MAR-2014 03:05:25 1       1       NO         TAG20140301T030504
6527    B  F  X DISK        02-MAR-2014 03:05:36 1       1       NO         TAG20140302T030523
6532    B  F  X DISK        03-MAR-2014 03:05:56 1       1       NO         TAG20140303T030537
6537    B  F  X DISK        04-MAR-2014 03:09:26 1       1       NO         TAG20140304T030854
6538    B  0  X DISK        05-MAR-2014 03:02:52 1       1       NO         HOT_DB_BK_LEVEL0
6539    B  0  X DISK        05-MAR-2014 03:03:21 1       1       NO         HOT_DB_BK_LEVEL0
6540    B  0  X DISK        05-MAR-2014 03:03:28 1       1       NO         HOT_DB_BK_LEVEL0
6541    B  0  X DISK        05-MAR-2014 03:04:21 1       1       NO         HOT_DB_BK_LEVEL0
6546    B  F  X DISK        05-MAR-2014 03:10:03 1       1       NO         TAG20140305T030943
6551    B  F  X DISK        06-MAR-2014 03:05:48 1       1       NO         TAG20140306T030526
6556    B  F  X DISK        07-MAR-2014 03:08:41 1       1       NO         TAG20140307T030818
6561    B  F  X DISK        08-MAR-2014 03:05:17 1       1       NO         TAG20140308T030456
6566    B  F  X DISK        09-MAR-2014 03:06:15 1       1       NO         TAG20140309T030556
6571    B  F  X DISK        10-MAR-2014 03:06:07 1       1       NO         TAG20140310T030548
6576    B  F  X DISK        11-MAR-2014 03:08:39 1       1       NO         TAG20140311T030818
6577    B  0  X DISK        12-MAR-2014 03:03:46 1       1       NO         HOT_DB_BK_LEVEL0
6578    B  0  X DISK        12-MAR-2014 03:04:17 1       1       NO         HOT_DB_BK_LEVEL0
6579    B  0  X DISK        12-MAR-2014 03:04:25 1       1       NO         HOT_DB_BK_LEVEL0
6580    B  0  X DISK        12-MAR-2014 03:05:39 1       1       NO         HOT_DB_BK_LEVEL0
6585    B  F  X DISK        12-MAR-2014 03:11:12 1       1       NO         TAG20140312T031059
6590    B  F  X DISK        13-MAR-2014 03:06:36 1       1       NO         TAG20140313T030613
6595    B  F  X DISK        14-MAR-2014 03:05:32 1       1       NO         TAG20140314T030513
6600    B  F  X DISK        15-MAR-2014 03:06:11 1       1       NO         TAG20140315T030550
6605    B  F  X DISK        16-MAR-2014 03:06:02 1       1       NO         TAG20140316T030542
6610    B  F  X DISK        17-MAR-2014 03:05:43 1       1       NO         TAG20140317T030524
6615    B  F  X DISK        18-MAR-2014 03:08:35 1       1       NO         TAG20140318T030812
6616    B  0  X DISK        19-MAR-2014 03:02:42 1       1       NO         HOT_DB_BK_LEVEL0
6617    B  0  X DISK        19-MAR-2014 03:03:12 1       1       NO         HOT_DB_BK_LEVEL0
6618    B  0  X DISK        19-MAR-2014 03:03:19 1       1       NO         HOT_DB_BK_LEVEL0
6619    B  0  X DISK        19-MAR-2014 03:04:03 1       1       NO         HOT_DB_BK_LEVEL0
6624    B  F  X DISK        19-MAR-2014 03:08:47 1       1       NO         TAG20140319T030828
6629    B  F  X DISK        20-MAR-2014 03:06:20 1       1       NO         TAG20140320T030608
6634    B  F  X DISK        21-MAR-2014 03:06:28 1       1       NO         TAG20140321T030608
6639    B  F  X DISK        22-MAR-2014 03:07:08 1       1       NO         TAG20140322T030650
6644    B  F  X DISK        23-MAR-2014 03:05:44 1       1       NO         TAG20140323T030524
6649    B  F  X DISK        24-MAR-2014 03:06:58 1       1       NO         TAG20140324T030634
6654    B  F  X DISK        25-MAR-2014 03:07:52 1       1       NO         TAG20140325T030729
6655    B  0  X DISK        26-MAR-2014 03:03:01 1       1       NO         HOT_DB_BK_LEVEL0
6656    B  0  X DISK        26-MAR-2014 03:03:25 1       1       NO         HOT_DB_BK_LEVEL0
6657    B  0  X DISK        26-MAR-2014 03:03:31 1       1       NO         HOT_DB_BK_LEVEL0
6658    B  0  X DISK        26-MAR-2014 03:04:29 1       1       NO         HOT_DB_BK_LEVEL0
6664    B  F  X DISK        26-MAR-2014 03:09:26 1       1       NO         TAG20140326T030905
6671    B  F  X DISK        27-MAR-2014 03:12:35 1       1       NO         TAG20140327T031211
6676    B  F  X DISK        28-MAR-2014 03:09:34 1       1       NO         TAG20140328T030903
6680    B  F  X DISK        29-MAR-2014 03:07:30 1       1       NO         TAG20140329T030708
6684    B  F  X DISK        30-MAR-2014 03:08:03 1       1       NO         TAG20140330T030741
6688    B  F  X DISK        31-MAR-2014 03:08:29 1       1       NO         TAG20140331T030808
6692    B  F  X DISK        01-APR-2014 03:10:54 1       1       NO         TAG20140401T031019
6693    B  0  X DISK        02-APR-2014 03:03:47 1       1       NO         HOT_DB_BK_LEVEL0
6694    B  0  X DISK        02-APR-2014 03:04:22 1       1       NO         HOT_DB_BK_LEVEL0
6695    B  0  X DISK        02-APR-2014 03:04:36 1       1       NO         HOT_DB_BK_LEVEL0
6696    B  0  X DISK        02-APR-2014 03:05:47 1       1       NO         HOT_DB_BK_LEVEL0
6700    B  F  X DISK        02-APR-2014 03:14:04 1       1       NO         TAG20140402T031340
6704    B  F  X DISK        03-APR-2014 03:08:15 1       1       NO         TAG20140403T030744
6708    B  F  X DISK        04-APR-2014 03:08:17 1       1       NO         TAG20140404T030756
6712    B  F  X DISK        05-APR-2014 03:11:12 1       1       NO         TAG20140405T031036
6716    B  F  X DISK        06-APR-2014 03:10:13 1       1       NO         TAG20140406T030939
6720    B  F  X DISK        07-APR-2014 03:08:06 1       1       NO         TAG20140407T030744
6724    B  F  X DISK        08-APR-2014 03:11:20 1       1       NO         TAG20140408T031044
6725    B  0  X DISK        09-APR-2014 03:04:04 1       1       NO         HOT_DB_BK_LEVEL0
6726    B  0  X DISK        09-APR-2014 03:04:46 1       1       NO         HOT_DB_BK_LEVEL0
6727    B  0  X DISK        09-APR-2014 03:04:58 1       1       NO         HOT_DB_BK_LEVEL0
6728    B  0  X DISK        09-APR-2014 03:06:43 1       1       NO         HOT_DB_BK_LEVEL0
6733    B  F  X DISK        09-APR-2014 03:14:59 1       1       NO         TAG20140409T031437
6737    B  F  X DISK        10-APR-2014 03:08:54 1       1       NO         TAG20140410T030822
6741    B  F  X DISK        11-APR-2014 03:09:14 1       1       NO         TAG20140411T030851
6745    B  F  X DISK        12-APR-2014 03:07:36 1       1       NO         TAG20140412T030714
6749    B  F  X DISK        13-APR-2014 03:08:28 1       1       NO         TAG20140413T030806
6753    B  F  X DISK        14-APR-2014 03:07:57 1       1       NO         TAG20140414T030735
6757    B  F  X DISK        15-APR-2014 03:08:50 1       1       NO         TAG20140415T030826
6758    B  0  X DISK        16-APR-2014 03:03:57 1       1       NO         HOT_DB_BK_LEVEL0
6759    B  0  X DISK        16-APR-2014 03:04:39 1       1       NO         HOT_DB_BK_LEVEL0
6760    B  0  X DISK        16-APR-2014 03:04:54 1       1       NO         HOT_DB_BK_LEVEL0
6761    B  0  X DISK        16-APR-2014 03:06:29 1       1       NO         HOT_DB_BK_LEVEL0
6765    B  F  X DISK        16-APR-2014 03:14:21 1       1       NO         TAG20140416T031358
6769    B  F  X DISK        17-APR-2014 03:08:18 1       1       NO         TAG20140417T030745
6773    B  F  X DISK        18-APR-2014 03:08:44 1       1       NO         TAG20140418T030820
6777    B  F  X DISK        19-APR-2014 03:08:56 1       1       NO         TAG20140419T030833
6781    B  F  X DISK        20-APR-2014 03:08:37 1       1       NO         TAG20140420T030813
6785    B  F  X DISK        21-APR-2014 03:10:09 1       1       NO         TAG20140421T030939
6789    B  F  X DISK        22-APR-2014 03:10:35 1       1       NO         TAG20140422T031000
6790    B  0  X DISK        23-APR-2014 03:03:44 1       1       NO         HOT_DB_BK_LEVEL0
6791    B  0  X DISK        23-APR-2014 03:04:21 1       1       NO         HOT_DB_BK_LEVEL0
6792    B  0  X DISK        23-APR-2014 03:04:29 1       1       NO         HOT_DB_BK_LEVEL0
6793    B  0  X DISK        23-APR-2014 03:05:20 1       1       NO         HOT_DB_BK_LEVEL0
6797    B  F  X DISK        23-APR-2014 03:14:00 1       1       NO         TAG20140423T031338
6801    B  F  X DISK        24-APR-2014 03:08:34 1       1       NO         TAG20140424T030812
6805    B  F  X DISK        25-APR-2014 03:08:51 1       1       NO         TAG20140425T030827
6809    B  F  X DISK        26-APR-2014 03:08:32 1       1       NO         TAG20140426T030809
6813    B  F  X DISK        27-APR-2014 03:08:33 1       1       NO         TAG20140427T030759
6817    B  F  X DISK        28-APR-2014 03:08:41 1       1       NO         TAG20140428T030819
6821    B  F  X DISK        29-APR-2014 03:11:29 1       1       NO         TAG20140429T031054
6822    B  0  X DISK        30-APR-2014 03:03:44 1       1       NO         HOT_DB_BK_LEVEL0
6823    B  0  X DISK        30-APR-2014 03:04:22 1       1       NO         HOT_DB_BK_LEVEL0
6824    B  0  X DISK        30-APR-2014 03:04:34 1       1       NO         HOT_DB_BK_LEVEL0
6825    B  0  X DISK        30-APR-2014 03:05:51 1       1       NO         HOT_DB_BK_LEVEL0
6830    B  F  X DISK        30-APR-2014 03:14:15 1       1       NO         TAG20140430T031355
6834    B  F  X DISK        01-MAY-2014 03:08:21 1       1       NO         TAG20140501T030757
6838    B  F  X DISK        02-MAY-2014 03:08:59 1       1       NO         TAG20140502T030835
6842    B  F  X DISK        03-MAY-2014 03:07:38 1       1       NO         TAG20140503T030706
6846    B  F  X DISK        04-MAY-2014 03:06:55 1       1       NO         TAG20140504T030621
6850    B  F  X DISK        05-MAY-2014 03:06:56 1       1       NO         TAG20140505T030623
6855    B  F  X DISK        06-MAY-2014 03:07:05 1       1       NO         TAG20140506T030644
6856    B  0  X DISK        07-MAY-2014 03:03:12 1       1       NO         HOT_DB_BK_LEVEL0
6857    B  0  X DISK        07-MAY-2014 03:03:38 1       1       NO         HOT_DB_BK_LEVEL0
6858    B  0  X DISK        07-MAY-2014 03:03:45 1       1       NO         HOT_DB_BK_LEVEL0
6859    B  0  X DISK        07-MAY-2014 03:05:16 1       1       NO         HOT_DB_BK_LEVEL0
6863    B  F  X DISK        07-MAY-2014 03:10:03 1       1       NO         TAG20140507T030941
6871    B  F  X DISK        08-MAY-2014 03:09:38 1       1       NO         TAG20140508T030917
6878    B  F  X DISK        09-MAY-2014 03:09:57 1       1       NO         TAG20140509T030936
6889    B  F  X DISK        10-MAY-2014 03:14:01 1       1       NO         TAG20140510T031341
6901    B  F  X DISK        11-MAY-2014 03:15:03 1       1       NO         TAG20140511T031442
6913    B  F  X DISK        12-MAY-2014 03:15:13 1       1       NO         TAG20140512T031453
6925    B  F  X DISK        13-MAY-2014 03:18:36 1       1       NO         TAG20140513T031814
6926    B  0  X DISK        14-MAY-2014 03:03:00 1       1       NO         HOT_DB_BK_LEVEL0
6927    B  0  X DISK        14-MAY-2014 03:03:27 1       1       NO         HOT_DB_BK_LEVEL0
6928    B  0  X DISK        14-MAY-2014 03:03:38 1       1       NO         HOT_DB_BK_LEVEL0
6929    B  0  X DISK        14-MAY-2014 03:04:58 1       1       NO         HOT_DB_BK_LEVEL0
6941    B  F  X DISK        14-MAY-2014 03:19:26 1       1       NO         TAG20140514T031906
6953    B  F  X DISK        15-MAY-2014 03:33:29 1       1       NO         TAG20140515T033254
6963    B  F  X DISK        16-MAY-2014 03:31:51 1       1       NO         TAG20140516T033113
6970    B  A  X DISK        17-MAY-2014 03:20:06 1       1       NO         TAG20140517T030241
6971    B  A  X DISK        17-MAY-2014 03:22:13 1       1       NO         TAG20140517T030241
6972    B  A  X DISK        17-MAY-2014 03:24:17 1       1       NO         TAG20140517T030241
6973    B  F  X DISK        17-MAY-2014 03:28:04 1       1       NO         TAG20140517T032727
6974    B  A  X DISK        18-MAY-2014 03:05:30 1       1       NO         TAG20140518T030232
6975    B  A  X DISK        18-MAY-2014 03:06:28 1       1       NO         TAG20140518T030232
6976    B  A  X DISK        18-MAY-2014 03:09:03 1       1       NO         TAG20140518T030232
6977    B  A  X DISK        18-MAY-2014 03:11:21 1       1       NO         TAG20140518T030232
6978    B  A  X DISK        18-MAY-2014 03:13:44 1       1       NO         TAG20140518T030232
6979    B  F  X DISK        18-MAY-2014 03:18:06 1       1       NO         TAG20140518T031729
6980    B  A  X DISK        19-MAY-2014 03:05:30 1       1       NO         TAG20140519T030228
6981    B  A  X DISK        19-MAY-2014 03:06:22 1       1       NO         TAG20140519T030228
6982    B  A  X DISK        19-MAY-2014 03:08:56 1       1       NO         TAG20140519T030228
6983    B  A  X DISK        19-MAY-2014 03:11:07 1       1       NO         TAG20140519T030228
6984    B  A  X DISK        19-MAY-2014 03:13:24 1       1       NO         TAG20140519T030228
6985    B  F  X DISK        19-MAY-2014 03:17:34 1       1       NO         TAG20140519T031657
6986    B  A  X DISK        20-MAY-2014 03:05:52 1       1       NO         TAG20140520T030257
6987    B  A  X DISK        20-MAY-2014 03:06:52 1       1       NO         TAG20140520T030257
6988    B  A  X DISK        20-MAY-2014 03:09:58 1       1       NO         TAG20140520T030257
6989    B  A  X DISK        20-MAY-2014 03:11:52 1       1       NO         TAG20140520T030257
6990    B  A  X DISK        20-MAY-2014 03:13:59 1       1       NO         TAG20140520T030257
6991    B  F  X DISK        20-MAY-2014 03:18:26 1       1       NO         TAG20140520T031733
6992    B  0  X DISK        21-MAY-2014 03:05:32 1       1       NO         HOT_DB_BK_LEVEL0
6993    B  0  X DISK        21-MAY-2014 03:06:30 1       1       NO         HOT_DB_BK_LEVEL0
6994    B  0  X DISK        21-MAY-2014 03:06:41 1       1       NO         HOT_DB_BK_LEVEL0
6995    B  0  X DISK        21-MAY-2014 03:09:00 1       1       NO         HOT_DB_BK_LEVEL0
6996    B  A  X DISK        21-MAY-2014 03:13:21 1       1       NO         TAG20140521T031153
6997    B  A  X DISK        21-MAY-2014 03:13:49 1       1       NO         TAG20140521T031153
6998    B  A  X DISK        21-MAY-2014 03:15:14 1       1       NO         TAG20140521T031153
6999    B  A  X DISK        21-MAY-2014 03:16:42 1       1       NO         TAG20140521T031153
7000    B  A  X DISK        21-MAY-2014 03:18:17 1       1       NO         TAG20140521T031153
7001    B  F  X DISK        21-MAY-2014 03:22:00 1       1       NO         TAG20140521T032123
7002    B  A  X DISK        22-MAY-2014 03:04:26 1       1       NO         TAG20140522T030236
7003    B  A  X DISK        22-MAY-2014 03:05:07 1       1       NO         TAG20140522T030236
7004    B  A  X DISK        22-MAY-2014 03:07:15 1       1       NO         TAG20140522T030236
7005    B  A  X DISK        22-MAY-2014 03:09:17 1       1       NO         TAG20140522T030236
7006    B  F  X DISK        22-MAY-2014 03:13:43 1       1       NO         TAG20140522T031307
7007    B  A  X DISK        23-MAY-2014 03:04:23 1       1       NO         TAG20140523T030232
7008    B  A  X DISK        23-MAY-2014 03:04:58 1       1       NO         TAG20140523T030232
7009    B  A  X DISK        23-MAY-2014 03:07:08 1       1       NO         TAG20140523T030232
7010    B  A  X DISK        23-MAY-2014 03:09:03 1       1       NO         TAG20140523T030232
7011    B  F  X DISK        23-MAY-2014 03:13:28 1       1       NO         TAG20140523T031241
7012    B  A  X DISK        24-MAY-2014 03:04:17 1       1       NO         TAG20140524T030235
7013    B  A  X DISK        24-MAY-2014 03:04:51 1       1       NO         TAG20140524T030235
7014    B  A  X DISK        24-MAY-2014 03:06:46 1       1       NO         TAG20140524T030235
7015    B  A  X DISK        24-MAY-2014 03:08:35 1       1       NO         TAG20140524T030235
7016    B  F  X DISK        24-MAY-2014 03:12:43 1       1       NO         TAG20140524T031205
7017    B  A  X DISK        25-MAY-2014 03:04:25 1       1       NO         TAG20140525T030232
7018    B  A  X DISK        25-MAY-2014 03:05:00 1       1       NO         TAG20140525T030232
7019    B  A  X DISK        25-MAY-2014 03:06:58 1       1       NO         TAG20140525T030232
7020    B  A  X DISK        25-MAY-2014 03:08:54 1       1       NO         TAG20140525T030232
7021    B  F  X DISK        25-MAY-2014 03:12:53 1       1       NO         TAG20140525T031217
7022    B  A  X DISK        26-MAY-2014 03:04:29 1       1       NO         TAG20140526T030237
7023    B  A  X DISK        26-MAY-2014 03:05:05 1       1       NO         TAG20140526T030237
7024    B  A  X DISK        26-MAY-2014 03:07:07 1       1       NO         TAG20140526T030237
7025    B  A  X DISK        26-MAY-2014 03:08:54 1       1       NO         TAG20140526T030237
7026    B  F  X DISK        26-MAY-2014 03:12:43 1       1       NO         TAG20140526T031209
7027    B  A  X DISK        27-MAY-2014 03:06:09 1       1       NO         TAG20140527T030301
7028    B  A  X DISK        27-MAY-2014 03:07:10 1       1       NO         TAG20140527T030301
7029    B  A  X DISK        27-MAY-2014 03:10:13 1       1       NO         TAG20140527T030301
7030    B  A  X DISK        27-MAY-2014 03:13:10 1       1       NO         TAG20140527T030301
7031    B  A  X DISK        27-MAY-2014 03:16:04 1       1       NO         TAG20140527T030301
7032    B  F  X DISK        27-MAY-2014 03:21:48 1       1       NO         TAG20140527T032054
7033    B  0  X DISK        28-MAY-2014 03:05:27 1       1       NO         HOT_DB_BK_LEVEL0
7034    B  0  X DISK        28-MAY-2014 03:06:18 1       1       NO         HOT_DB_BK_LEVEL0
7035    B  0  X DISK        28-MAY-2014 03:06:30 1       1       NO         HOT_DB_BK_LEVEL0
7036    B  0  X DISK        28-MAY-2014 03:09:16 1       1       NO         HOT_DB_BK_LEVEL0
7037    B  A  X DISK        28-MAY-2014 03:14:02 1       1       NO         TAG20140528T031149
7038    B  A  X DISK        28-MAY-2014 03:14:42 1       1       NO         TAG20140528T031149
7039    B  A  X DISK        28-MAY-2014 03:16:53 1       1       NO         TAG20140528T031149
7040    B  A  X DISK        28-MAY-2014 03:19:17 1       1       NO         TAG20140528T031149
7041    B  F  X DISK        28-MAY-2014 03:23:47 1       1       NO         TAG20140528T032301
7042    B  A  X DISK        29-MAY-2014 03:04:48 1       1       NO         TAG20140529T030237
7043    B  A  X DISK        29-MAY-2014 03:05:39 1       1       NO         TAG20140529T030237
7044    B  A  X DISK        29-MAY-2014 03:08:10 1       1       NO         TAG20140529T030237
7045    B  A  X DISK        29-MAY-2014 03:10:22 1       1       NO         TAG20140529T030237
7046    B  F  X DISK        29-MAY-2014 03:14:44 1       1       NO         TAG20140529T031357
7047    B  A  X DISK        30-MAY-2014 03:04:55 1       1       NO         TAG20140530T030249
7048    B  A  X DISK        30-MAY-2014 03:05:35 1       1       NO         TAG20140530T030249
7049    B  A  X DISK        30-MAY-2014 03:07:42 1       1       NO         TAG20140530T030249
7050    B  A  X DISK        30-MAY-2014 03:09:31 1       1       NO         TAG20140530T030249
7051    B  F  X DISK        30-MAY-2014 03:13:16 1       1       NO         TAG20140530T031230
7052    B  A  X DISK        31-MAY-2014 03:04:56 1       1       NO         TAG20140531T030238
7053    B  A  X DISK        31-MAY-2014 03:05:44 1       1       NO         TAG20140531T030238
7054    B  A  X DISK        31-MAY-2014 03:08:20 1       1       NO         TAG20140531T030238
7055    B  A  X DISK        31-MAY-2014 03:10:23 1       1       NO         TAG20140531T030238
7056    B  F  X DISK        31-MAY-2014 03:14:33 1       1       NO         TAG20140531T031357
7057    B  A  X DISK        01-JUN-2014 03:05:50 1       1       NO         TAG20140601T030241
7058    B  A  X DISK        01-JUN-2014 03:06:43 1       1       NO         TAG20140601T030241
7059    B  A  X DISK        01-JUN-2014 03:09:10 1       1       NO         TAG20140601T030241
7060    B  A  X DISK        01-JUN-2014 03:11:28 1       1       NO         TAG20140601T030241
7061    B  A  X DISK        01-JUN-2014 03:13:56 1       1       NO         TAG20140601T030241
7062    B  A  X DISK        01-JUN-2014 03:16:17 1       1       NO         TAG20140601T030241
7063    B  F  X DISK        01-JUN-2014 03:21:03 1       1       NO         TAG20140601T032012
7064    B  A  X DISK        02-JUN-2014 03:05:58 1       1       NO         TAG20140602T030302
7065    B  A  X DISK        02-JUN-2014 03:06:52 1       1       NO         TAG20140602T030302
7066    B  A  X DISK        02-JUN-2014 03:09:39 1       1       NO         TAG20140602T030302
7067    B  A  X DISK        02-JUN-2014 03:12:06 1       1       NO         TAG20140602T030302
7068    B  A  X DISK        02-JUN-2014 03:14:23 1       1       NO         TAG20140602T030302
7069    B  F  X DISK        02-JUN-2014 03:18:54 1       1       NO         TAG20140602T031815
7070    B  A  X DISK        03-JUN-2014 03:06:36 1       1       NO         TAG20140603T030309
7071    B  A  X DISK        03-JUN-2014 03:07:48 1       1       NO         TAG20140603T030309
7072    B  A  X DISK        03-JUN-2014 03:11:23 1       1       NO         TAG20140603T030309
7073    B  A  X DISK        03-JUN-2014 03:14:43 1       1       NO         TAG20140603T030309
7074    B  A  X DISK        03-JUN-2014 03:16:59 1       1       NO         TAG20140603T030309
7075    B  F  X DISK        03-JUN-2014 03:21:37 1       1       NO         TAG20140603T032048
7076    B  0  X DISK        04-JUN-2014 03:06:11 1       1       NO         HOT_DB_BK_LEVEL0
7077    B  0  X DISK        04-JUN-2014 03:07:14 1       1       NO         HOT_DB_BK_LEVEL0
7078    B  0  X DISK        04-JUN-2014 03:07:25 1       1       NO         HOT_DB_BK_LEVEL0
7079    B  0  X DISK        04-JUN-2014 03:10:26 1       1       NO         HOT_DB_BK_LEVEL0
7080    B  A  X DISK        04-JUN-2014 03:16:21 1       1       NO         TAG20140604T031333
7081    B  A  X DISK        04-JUN-2014 03:17:26 1       1       NO         TAG20140604T031333
7082    B  A  X DISK        04-JUN-2014 03:20:42 1       1       NO         TAG20140604T031333
7083    B  A  X DISK        04-JUN-2014 03:22:42 1       1       NO         TAG20140604T031333
7084    B  F  X DISK        04-JUN-2014 03:26:38 1       1       NO         TAG20140604T032552
7085    B  A  X DISK        05-JUN-2014 03:05:29 1       1       NO         TAG20140605T030300
7086    B  A  X DISK        05-JUN-2014 03:06:26 1       1       NO         TAG20140605T030300
7087    B  A  X DISK        05-JUN-2014 03:09:20 1       1       NO         TAG20140605T030300
7088    B  F  X DISK        05-JUN-2014 03:14:35 1       1       NO         TAG20140605T031347
7089    B  A  X DISK        06-JUN-2014 03:05:12 1       1       NO         TAG20140606T030242
7090    B  A  X DISK        06-JUN-2014 03:06:09 1       1       NO         TAG20140606T030242
7091    B  A  X DISK        06-JUN-2014 03:09:06 1       1       NO         TAG20140606T030242
7092    B  F  X DISK        06-JUN-2014 03:14:11 1       1       NO         TAG20140606T031320
7093    B  A  X DISK        07-JUN-2014 03:07:09 1       1       NO         TAG20140607T030307
7094    B  A  X DISK        07-JUN-2014 03:08:41 1       1       NO         TAG20140607T030307
7095    B  A  X DISK        07-JUN-2014 03:11:31 1       1       NO         TAG20140607T030307
7096    B  A  X DISK        07-JUN-2014 03:14:37 1       1       NO         TAG20140607T030307
7097    B  A  X DISK        07-JUN-2014 03:17:33 1       1       NO         TAG20140607T030307
7098    B  F  X DISK        07-JUN-2014 03:22:59 1       1       NO         TAG20140607T032210
7099    B  A  X DISK        08-JUN-2014 03:05:11 1       1       NO         TAG20140608T030256
7100    B  A  X DISK        08-JUN-2014 03:06:08 1       1       NO         TAG20140608T030256
7101    B  A  X DISK        08-JUN-2014 03:08:46 1       1       NO         TAG20140608T030256
7102    B  F  X DISK        08-JUN-2014 03:13:14 1       1       NO         TAG20140608T031238
7103    B  A  X DISK        09-JUN-2014 03:05:31 1       1       NO         TAG20140609T030234
7104    B  A  X DISK        09-JUN-2014 03:06:40 1       1       NO         TAG20140609T030234
7105    B  A  X DISK        09-JUN-2014 03:09:18 1       1       NO         TAG20140609T030234
7106    B  A  X DISK        09-JUN-2014 03:11:40 1       1       NO         TAG20140609T030234
7107    B  F  X DISK        09-JUN-2014 03:15:59 1       1       NO         TAG20140609T031521
7108    B  A  X DISK        10-JUN-2014 03:06:21 1       1       NO         TAG20140610T030313
7109    B  A  X DISK        10-JUN-2014 03:07:43 1       1       NO         TAG20140610T030313
7110    B  A  X DISK        10-JUN-2014 03:10:51 1       1       NO         TAG20140610T030313
7111    B  F  X DISK        10-JUN-2014 03:16:41 1       1       NO         TAG20140610T031551
7112    B  0  X DISK        11-JUN-2014 03:06:12 1       1       NO         HOT_DB_BK_LEVEL0
7113    B  0  X DISK        11-JUN-2014 03:07:39 1       1       NO         HOT_DB_BK_LEVEL0
7114    B  0  X DISK        11-JUN-2014 03:08:03 1       1       NO         HOT_DB_BK_LEVEL0
7115    B  0  X DISK        11-JUN-2014 03:11:14 1       1       NO         HOT_DB_BK_LEVEL0
7116    B  A  X DISK        11-JUN-2014 03:18:00 1       1       NO         TAG20140611T031519
7117    B  A  X DISK        11-JUN-2014 03:18:56 1       1       NO         TAG20140611T031519
7118    B  A  X DISK        11-JUN-2014 03:21:20 1       1       NO         TAG20140611T031519
7119    B  A  X DISK        11-JUN-2014 03:23:53 1       1       NO         TAG20140611T031519
7120    B  F  X DISK        11-JUN-2014 03:28:46 1       1       NO         TAG20140611T032801
7121    B  A  X DISK        12-JUN-2014 03:06:26 1       1       NO         TAG20140612T030310
7122    B  A  X DISK        12-JUN-2014 03:07:36 1       1       NO         TAG20140612T030310
7123    B  A  X DISK        12-JUN-2014 03:11:24 1       1       NO         TAG20140612T030310
7124    B  F  X DISK        12-JUN-2014 03:17:40 1       1       NO         TAG20140612T031651
7125    B  A  X DISK        13-JUN-2014 03:04:43 1       1       NO         TAG20140613T030157
7126    B  A  X DISK        13-JUN-2014 03:05:36 1       1       NO         TAG20140613T030157
7127    B  A  X DISK        13-JUN-2014 03:07:13 1       1       NO         TAG20140613T030157
7128    B  F  X DISK        13-JUN-2014 03:12:00 1       1       NO         TAG20140613T031105
7129    B  A  X DISK        14-JUN-2014 03:05:08 1       1       NO         TAG20140614T030217
7130    B  A  X DISK        14-JUN-2014 03:05:57 1       1       NO         TAG20140614T030217
7131    B  A  X DISK        14-JUN-2014 03:08:35 1       1       NO         TAG20140614T030217
7132    B  A  X DISK        14-JUN-2014 03:10:57 1       1       NO         TAG20140614T030217
7133    B  A  X DISK        14-JUN-2014 03:13:13 1       1       NO         TAG20140614T030217
7134    B  F  X DISK        14-JUN-2014 03:17:35 1       1       NO         TAG20140614T031702
7135    B  A  X DISK        15-JUN-2014 03:03:57 1       1       NO         TAG20140615T030206
7136    B  A  X DISK        15-JUN-2014 03:04:35 1       1       NO         TAG20140615T030206
7137    B  A  X DISK        15-JUN-2014 03:06:29 1       1       NO         TAG20140615T030206
7138    B  A  X DISK        15-JUN-2014 03:08:25 1       1       NO         TAG20140615T030206
7139    B  F  X DISK        15-JUN-2014 03:11:49 1       1       NO         TAG20140615T031115
7140    B  A  X DISK        16-JUN-2014 03:04:10 1       1       NO         TAG20140616T030205
7141    B  A  X DISK        16-JUN-2014 03:04:51 1       1       NO         TAG20140616T030205
7142    B  A  X DISK        16-JUN-2014 03:06:41 1       1       NO         TAG20140616T030205
7143    B  A  X DISK        16-JUN-2014 03:08:30 1       1       NO         TAG20140616T030205
7144    B  F  X DISK        16-JUN-2014 03:11:51 1       1       NO         TAG20140616T031115
7145    B  A  X DISK        17-JUN-2014 03:05:32 1       1       NO         TAG20140617T030242
7146    B  A  X DISK        17-JUN-2014 03:06:36 1       1       NO         TAG20140617T030242
7147    B  A  X DISK        17-JUN-2014 03:09:24 1       1       NO         TAG20140617T030242
7148    B  A  X DISK        17-JUN-2014 03:11:54 1       1       NO         TAG20140617T030242
7149    B  F  X DISK        17-JUN-2014 03:16:34 1       1       NO         TAG20140617T031546
7150    B  0  X DISK        18-JUN-2014 03:04:48 1       1       NO         HOT_DB_BK_LEVEL0
7151    B  0  X DISK        18-JUN-2014 03:05:35 1       1       NO         HOT_DB_BK_LEVEL0
7152    B  0  X DISK        18-JUN-2014 03:05:50 1       1       NO         HOT_DB_BK_LEVEL0
7153    B  0  X DISK        18-JUN-2014 03:08:18 1       1       NO         HOT_DB_BK_LEVEL0
7154    B  A  X DISK        18-JUN-2014 03:12:27 1       1       NO         TAG20140618T030943
7155    B  A  X DISK        18-JUN-2014 03:13:16 1       1       NO         TAG20140618T030943
7156    B  A  X DISK        18-JUN-2014 03:15:21 1       1       NO         TAG20140618T030943
7157    B  A  X DISK        18-JUN-2014 03:17:32 1       1       NO         TAG20140618T030943
7158    B  A  X DISK        18-JUN-2014 03:19:35 1       1       NO         TAG20140618T030943
7159    B  F  X DISK        18-JUN-2014 03:23:10 1       1       NO         TAG20140618T032237
7160    B  A  X DISK        19-JUN-2014 03:05:29 1       1       NO         TAG20140619T030212
7161    B  A  X DISK        19-JUN-2014 03:06:13 1       1       NO         TAG20140619T030212
7162    B  A  X DISK        19-JUN-2014 03:08:23 1       1       NO         TAG20140619T030212
7163    B  A  X DISK        19-JUN-2014 03:10:28 1       1       NO         TAG20140619T030212
7164    B  A  X DISK        19-JUN-2014 03:12:24 1       1       NO         TAG20140619T030212
7165    B  A  X DISK        19-JUN-2014 03:14:27 1       1       NO         TAG20140619T030212
7166    B  A  X DISK        19-JUN-2014 03:16:29 1       1       NO         TAG20140619T030212
7167    B  A  X DISK        19-JUN-2014 03:18:00 1       1       NO         TAG20140619T030212
7168    B  F  X DISK        19-JUN-2014 03:20:46 1       1       NO         TAG20140619T032012
7169    B  A  X DISK        20-JUN-2014 03:04:43 1       1       NO         TAG20140620T030213
7170    B  A  X DISK        20-JUN-2014 03:05:22 1       1       NO         TAG20140620T030213
7171    B  A  X DISK        20-JUN-2014 03:07:12 1       1       NO         TAG20140620T030213
7172    B  A  X DISK        20-JUN-2014 03:08:48 1       1       NO         TAG20140620T030213
7173    B  A  X DISK        20-JUN-2014 03:09:58 1       1       NO         TAG20140620T030213
7174    B  A  X DISK        20-JUN-2014 03:11:15 1       1       NO         TAG20140620T030213
7175    B  F  X DISK        20-JUN-2014 03:14:37 1       1       NO         TAG20140620T031403
7176    B  A  X DISK        21-JUN-2014 03:03:31 1       1       NO         TAG20140621T030204
7177    B  A  X DISK        21-JUN-2014 03:03:57 1       1       NO         TAG20140621T030204
7178    B  A  X DISK        21-JUN-2014 03:05:28 1       1       NO         TAG20140621T030204
7179    B  A  X DISK        21-JUN-2014 03:07:14 1       1       NO         TAG20140621T030204
7180    B  A  X DISK        21-JUN-2014 03:08:51 1       1       NO         TAG20140621T030204
7181    B  F  X DISK        21-JUN-2014 03:12:06 1       1       NO         TAG20140621T031133
7182    B  A  X DISK        22-JUN-2014 03:03:48 1       1       NO         TAG20140622T030215
7183    B  A  X DISK        22-JUN-2014 03:04:20 1       1       NO         TAG20140622T030215
7184    B  A  X DISK        22-JUN-2014 03:05:57 1       1       NO         TAG20140622T030215
7185    B  A  X DISK        22-JUN-2014 03:07:54 1       1       NO         TAG20140622T030215
7186    B  F  X DISK        22-JUN-2014 03:11:30 1       1       NO         TAG20140622T031052
7187    B  A  X DISK        23-JUN-2014 03:03:52 1       1       NO         TAG20140623T030208
7188    B  A  X DISK        23-JUN-2014 03:04:26 1       1       NO         TAG20140623T030208
7189    B  A  X DISK        23-JUN-2014 03:06:20 1       1       NO         TAG20140623T030208
7190    B  A  X DISK        23-JUN-2014 03:08:18 1       1       NO         TAG20140623T030208
7191    B  F  X DISK        23-JUN-2014 03:12:07 1       1       NO         TAG20140623T031133
7192    B  A  X DISK        24-JUN-2014 03:05:36 1       1       NO         TAG20140624T030246
7193    B  A  X DISK        24-JUN-2014 03:06:29 1       1       NO         TAG20140624T030246
7194    B  A  X DISK        24-JUN-2014 03:09:31 1       1       NO         TAG20140624T030246
7195    B  A  X DISK        24-JUN-2014 03:12:12 1       1       NO         TAG20140624T030246
7196    B  A  X DISK        24-JUN-2014 03:14:09 1       1       NO         TAG20140624T030246
7197    B  F  X DISK        24-JUN-2014 03:18:13 1       1       NO         TAG20140624T031726
7198    B  0  X DISK        25-JUN-2014 03:04:46 1       1       NO         HOT_DB_BK_LEVEL0
7199    B  0  X DISK        25-JUN-2014 03:05:26 1       1       NO         HOT_DB_BK_LEVEL0
7200    B  0  X DISK        25-JUN-2014 03:05:40 1       1       NO         HOT_DB_BK_LEVEL0
7201    B  0  X DISK        25-JUN-2014 03:07:51 1       1       NO         HOT_DB_BK_LEVEL0
7202    B  A  X DISK        25-JUN-2014 03:12:02 1       1       NO         TAG20140625T031010
7203    B  A  X DISK        25-JUN-2014 03:12:36 1       1       NO         TAG20140625T031010
7204    B  A  X DISK        25-JUN-2014 03:14:30 1       1       NO         TAG20140625T031010
7205    B  A  X DISK        25-JUN-2014 03:16:20 1       1       NO         TAG20140625T031010
7206    B  F  X DISK        25-JUN-2014 03:20:19 1       1       NO         TAG20140625T031942
7207    B  A  X DISK        26-JUN-2014 03:03:55 1       1       NO         TAG20140626T030217
7208    B  A  X DISK        26-JUN-2014 03:04:34 1       1       NO         TAG20140626T030217
7209    B  A  X DISK        26-JUN-2014 03:06:35 1       1       NO         TAG20140626T030217
7210    B  F  X DISK        26-JUN-2014 03:10:49 1       1       NO         TAG20140626T031014
7211    B  A  X DISK        27-JUN-2014 03:04:14 1       1       NO         TAG20140627T030228
7212    B  A  X DISK        27-JUN-2014 03:04:54 1       1       NO         TAG20140627T030228
7213    B  A  X DISK        27-JUN-2014 03:07:12 1       1       NO         TAG20140627T030228
7214    B  F  X DISK        27-JUN-2014 03:11:13 1       1       NO         TAG20140627T031039
7215    B  A  X DISK        28-JUN-2014 03:05:16 1       1       NO         TAG20140628T030235
7216    B  A  X DISK        28-JUN-2014 03:06:01 1       1       NO         TAG20140628T030235
7217    B  A  X DISK        28-JUN-2014 03:08:19 1       1       NO         TAG20140628T030235
7218    B  A  X DISK        28-JUN-2014 03:10:42 1       1       NO         TAG20140628T030235
7219    B  A  X DISK        28-JUN-2014 03:13:01 1       1       NO         TAG20140628T030235
7220    B  A  X DISK        28-JUN-2014 03:14:53 1       1       NO         TAG20140628T030235
7221    B  F  X DISK        28-JUN-2014 03:18:50 1       1       NO         TAG20140628T031804
7222    B  A  X DISK        29-JUN-2014 03:04:46 1       1       NO         TAG20140629T030232
7223    B  A  X DISK        29-JUN-2014 03:05:30 1       1       NO         TAG20140629T030232
7224    B  A  X DISK        29-JUN-2014 03:07:49 1       1       NO         TAG20140629T030232
7225    B  A  X DISK        29-JUN-2014 03:09:55 1       1       NO         TAG20140629T030232
7226    B  F  X DISK        29-JUN-2014 03:13:59 1       1       NO         TAG20140629T031324
7227    B  A  X DISK        30-JUN-2014 03:04:20 1       1       NO         TAG20140630T030221
7228    B  A  X DISK        30-JUN-2014 03:05:04 1       1       NO         TAG20140630T030221
7229    B  A  X DISK        30-JUN-2014 03:07:35 1       1       NO         TAG20140630T030221
7230    B  F  X DISK        30-JUN-2014 03:11:39 1       1       NO         TAG20140630T031103
7231    B  A  X DISK        01-JUL-2014 03:05:04 1       1       NO         TAG20140701T030248
7232    B  A  X DISK        01-JUL-2014 03:05:58 1       1       NO         TAG20140701T030248
7233    B  A  X DISK        01-JUL-2014 03:08:30 1       1       NO         TAG20140701T030248
7234    B  F  X DISK        01-JUL-2014 03:13:17 1       1       NO         TAG20140701T031232
7235    B  0  A DISK        02-JUL-2014 03:05:17 1       2       NO         HOT_DB_BK_LEVEL0
7236    B  0  A DISK        02-JUL-2014 03:06:03 1       2       NO         HOT_DB_BK_LEVEL0
7237    B  0  A DISK        02-JUL-2014 03:06:19 1       2       NO         HOT_DB_BK_LEVEL0
7238    B  0  A DISK        02-JUL-2014 03:08:23 1       2       NO         HOT_DB_BK_LEVEL0
7239    B  A  A DISK        02-JUL-2014 03:12:33 1       2       NO         TAG20140702T031035
7240    B  A  A DISK        02-JUL-2014 03:13:18 1       2       NO         TAG20140702T031035
7241    B  A  A DISK        02-JUL-2014 03:15:28 1       2       NO         TAG20140702T031035
7242    B  F  A DISK        02-JUL-2014 03:19:19 1       1       NO         TAG20140702T031918

RMAN> exit


Recovery Manager complete.


RESTORE DATAFILE
This is the RMAN script we will be use to restore DATAFILE :
run {
ALLOCATE CHANNEL DBBACKUP1 TYPE DISK;
ALLOCATE CHANNEL DBBACKUP2 TYPE DISK;
SET NEWNAME FOR DATABASE TO '/u01/app/oracle/oradata/mgw/%b';
SET NEWNAME FOR tempfile 1 TO '/u01/app/oracle/oradata/mgw/%b';
restore database;
switch datafile all;
switch tempfile all;
RELEASE CHANNEL DBBACKUP1;
RELEASE CHANNEL DBBACKUP2;
}

[oracle@nicole ~]$ rman target /

Recovery Manager: Release 11.2.0.2.0 - Production on Fri Jul 25 19:57:13 2014

Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.

connected to target database: MGW (DBID=2176662940, not open)

RMAN> run {
ALLOCATE CHANNEL DBBACKUP1 TYPE DISK;
ALLOCATE CHANNEL DBBACKUP2 TYPE DISK;
SET NEWNAME FOR DATABASE TO '/u01/app/oracle/oradata/mgw/%b';
SET NEWNAME FOR tempfile 1 TO '/u01/app/oracle/oradata/mgw/%b';
restore database;
switch datafile all;
switch tempfile all;
RELEASE CHANNEL DBBACKUP1;
RELEASE CHANNEL DBBACKUP2;
}

executing command: SET NEWNAME

executing command: SET NEWNAME

Starting restore at 25-JUL-2014 20:03:35
using target database control file instead of recovery catalog
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=21 device type=DISK

channel ORA_DISK_1: starting datafile backup set restore
channel ORA_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_DISK_1: restoring datafile 00001 to /u01/app/oracle/oradata/mgw/system.256.739189653
channel ORA_DISK_1: restoring datafile 00004 to /u01/app/oracle/oradata/mgw/users.259.739189655
channel ORA_DISK_1: restoring datafile 00006 to /u01/app/oracle/oradata/mgw/mgw.340.782737261
channel ORA_DISK_1: restoring datafile 00007 to /u01/app/oracle/oradata/mgw/mgwdata.341.782737315
channel ORA_DISK_1: reading from backup piece /u01/app/backupset/fullbk_mgw1_7285_1_851828562
channel ORA_DISK_1: piece handle=/u01/app/backupset/fullbk_mgw1_7285_1_851828562 tag=HOT_DB_BK_LEVEL0
channel ORA_DISK_1: restored backup piece 1
channel ORA_DISK_1: restore complete, elapsed time: 00:04:39
channel ORA_DISK_1: starting datafile backup set restore
channel ORA_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_DISK_1: restoring datafile 00002 to /u01/app/oracle/oradata/mgw/sysaux.257.739189653
channel ORA_DISK_1: restoring datafile 00003 to /u01/app/oracle/oradata/mgw/undotbs1.258.739189655
channel ORA_DISK_1: restoring datafile 00005 to /u01/app/oracle/oradata/mgw/undotbs2.264.739189747
channel ORA_DISK_1: reading from backup piece /u01/app/backupset/fullbk_mgw1_7284_1_851828556
channel ORA_DISK_1: piece handle=/u01/app/backupset/fullbk_mgw1_7284_1_851828556 tag=HOT_DB_BK_LEVEL0
channel ORA_DISK_1: restored backup piece 1
channel ORA_DISK_1: restore complete, elapsed time: 00:07:05
Finished restore at 25-JUL-2014 20:15:19

datafile 1 switched to datafile copy
input datafile copy RECID=8 STAMP=853877721 file name=/u01/app/oracle/oradata/mgw/system.256.739189653
datafile 2 switched to datafile copy
input datafile copy RECID=9 STAMP=853877721 file name=/u01/app/oracle/oradata/mgw/sysaux.257.739189653
datafile 3 switched to datafile copy
input datafile copy RECID=10 STAMP=853877721 file name=/u01/app/oracle/oradata/mgw/undotbs1.258.739189655
datafile 4 switched to datafile copy
input datafile copy RECID=11 STAMP=853877722 file name=/u01/app/oracle/oradata/mgw/users.259.739189655
datafile 5 switched to datafile copy
input datafile copy RECID=12 STAMP=853877722 file name=/u01/app/oracle/oradata/mgw/undotbs2.264.739189747
datafile 6 switched to datafile copy
input datafile copy RECID=13 STAMP=853877722 file name=/u01/app/oracle/oradata/mgw/mgw.340.782737261
datafile 7 switched to datafile copy
input datafile copy RECID=14 STAMP=853877722 file name=/u01/app/oracle/oradata/mgw/mgwdata.341.782737315

renamed tempfile 1 to /u01/app/oracle/oradata/mgw/temp.263.739189731 in control file

CHECK WHICH THREAD WILL BE USED FOR RECOVER
SQL> select thread#,min(sequence#),max(next_change#) from v$archived_log group by thread# order by 1,2;

   THREAD# MAX(NEXT_CHANGE#)
---------- -----------------
	 1	  7661405132
	 2	  7661405117

SQL> select thread#,max(sequence#),max(next_change#) from v$archived_log group by thread# order by 1,2;

   THREAD# MAX(SEQUENCE#) MAX(NEXT_CHANGE#)
---------- -------------- -----------------
	 1	    45592	 7661447747
	 2	    49039	 7661405126

--Tanggal 16 July
SQL> select thread#,max(sequence#),max(next_change#) from v$archived_log group by thread# order by 1,2;

   THREAD# MAX(SEQUENCE#) MAX(NEXT_CHANGE#)
---------- -------------- -----------------
	 1	    45982	 7736787364
	 2	    49591	 7736787376

run {
set until sequence 45982 thread 1;
recover database;
}

------------------------------------------------------------------------------------------------------
--Tanggal 9 Juli 2014
SQL> select thread#,max(sequence#),max(next_change#) from v$archived_log group by thread# order by 1,2;

   THREAD# MAX(SEQUENCE#) MAX(NEXT_CHANGE#)
---------- -------------- -----------------
	 1	    45790	 7699647283
	 2	    49317	 7699647136

SQL>

run {
set until sequence 49317 thread 2;
recover database;
}

recover database script (pick which thread having lowest NEXT_CHANGE#, and give +1 in sequence#:

run {
set until sequence 49040 thread 2;
recover database;
}

RECOVER PROCESS
[oracle@nicole ~]$ rman target /

Recovery Manager: Release 11.2.0.2.0 - Production on Fri Jul 25 20:35:10 2014

Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.

connected to target database: MGW (DBID=2176662940, not open)

RMAN> run {
set until sequence 49040 thread 2;
recover database;
}2> 3> 4> 

executing command: SET until clause

Starting recover at JUL-25-2014 20:35:14
using target database control file instead of recovery catalog
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=19 device type=DISK

starting media recovery
media recovery complete, elapsed time: 00:00:00

Finished recover at JUL-25-2014 20:35:15

RMAN> exit

SQL> alter database open resetlogs;

Database altered.

SQL> select member from v$logfile;  

MEMBER
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/u01/app/oracle/oradata/MGW/onlinelog/o1_mf_2_9x4q9zk5_.log
/u01/app/oracle/oradata/MGW/onlinelog/o1_mf_1_9x4q9xpk_.log
/u01/app/oracle/oradata/MGW/onlinelog/o1_mf_3_9x4qb19v_.log
/u01/app/oracle/oradata/MGW/onlinelog/o1_mf_4_9x4qb4jv_.log

backup schema
Backup MGW dan MGWTEST 20140702
create directory datapump as '/u01/app/datapump';

expdp \'/ as sysdba\'  schemas=MGW directory=datapump dumpfile=EXPDP_MGW_20140702.dmp logfile=EXPDP_MGW_20140702.log compression=data_only parallel=2

expdp \'/ as sysdba\'  schemas=MGWTEST directory=datapump dumpfile=EXPDP_MGWTEST_20140702.dmp logfile=EXPDP_MGWTEST_20140702.log compression=data_only parallel=2

expdp \'/ as sysdba\'  schemas=MGW directory=datapump dumpfile=EXPDP_MGW_20140716.dmp logfile=EXPDP_MGW_20140716.log compression=data_only parallel=2

expdp \'/ as sysdba\'  schemas=MGW directory=datapump dumpfile=EXPDP_MGW_20140709.dmp logfile=EXPDP_MGW_20140709.log compression=data_only parallel=2


