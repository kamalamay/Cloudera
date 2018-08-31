Referensi:
http://gavinsoorma.com/2010/03/11g-data-guard-broker-dgmgrl-configuration-quick-steps/
https://oracle-base.com/articles/12c/data-guard-setup-using-broker-12cr1

bandung.indonesia.com
---------------------
SQL> SELECT DATABASE_ROLE FROM V$DATABASE;

DATABASE_ROLE
----------------
PRIMARY

Elapsed: 00:00:00.00
SQL> SELECT DATABASE_ROLE FROM V$DATABASE;

DATABASE_ROLE
----------------
PRIMARY

Elapsed: 00:00:00.00
SQL> !hostname
bandung.indonesia.com

SQL> SHO PARAMETER dg_broker_start

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
dg_broker_start                      boolean     FALSE
SQL> ALTER SYSTEM SET dg_broker_start=TRUE SCOPE=BOTH;

System altered.

Elapsed: 00:00:00.08
SQL> SHO PARAMETER dg_broker_start

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
dg_broker_start                      boolean     TRUE
SQL>

jakarta.indonesia.com
---------------------
SQL> !hostname
jakarta.indonesia.com

SQL> SELECT DATABASE_ROLE FROM V$DATABASE;
SP2-0640: Not connected
SQL> CONN SYS/oracle as sysdba
Connected.
SQL> SELECT DATABASE_ROLE FROM V$DATABASE;

DATABASE_ROLE
----------------
PHYSICAL STANDBY

Elapsed: 00:00:00.00
SQL> ALTER SYSTEM SET dg_broker_start=TRUE SCOPE=BOTH;

System altered.

Elapsed: 00:00:00.12
SQL> SHO PARAMETER dg_broker_start

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
dg_broker_start                      boolean     TRUE
SQL>

bandung.indonesia.com
---------------------
[oracle@bandung ~]$ rlwrap dgmgrl
DGMGRL for Linux: Version 11.2.0.1.0 - 64bit Production

Copyright (c) 2000, 2009, Oracle. All rights reserved.

Welcome to DGMGRL, type "help" for information.
DGMGRL> connect sys/oracle
Connected.
DGMGRL> CREATE CONFIGURATION 'KotaDR' AS PRIMARY DATABASE IS 'BDG' CONNECT IDENTIFIER IS 'BDG';
Configuration "KotaDR" created with primary database "BDG"
DGMGRL> ADD DATABASE 'JKT' AS CONNECT IDENTIFIER IS 'JKT';
Database "JKT" added
DGMGRL> SHOW CONFIGURATION

Configuration - KotaDR

  Protection Mode: MaxPerformance
  Databases:
    BDG - Primary database
    JKT - Physical standby database

Fast-Start Failover: DISABLED

Configuration Status:
DISABLED

DGMGRL> ENABLE CONFIGURATION
Enabled.
DGMGRL> SHOW CONFIGURATION

Configuration - KotaDR

  Protection Mode: MaxPerformance
  Databases:
    BDG - Primary database
    JKT - Physical standby database

Fast-Start Failover: DISABLED

Configuration Status:
SUCCESS

DGMGRL> SHOW DATABASE 'BDG'

Database - BDG

  Role:            PRIMARY
  Intended State:  TRANSPORT-ON
  Instance(s):
    bdg

Database Status:
SUCCESS

DGMGRL> SHOW DATABASE 'JKT'

Database - JKT

  Role:            PHYSICAL STANDBY
  Intended State:  APPLY-ON
  Transport Lag:   0 seconds
  Apply Lag:       0 seconds
  Real Time Query: OFF
  Instance(s):
    jkt

Database Status:
SUCCESS

DGMGRL> SHOW DATABASE VERBOSE 'BDG'

Database - BDG

  Role:            PRIMARY
  Intended State:  TRANSPORT-ON
  Instance(s):
    bdg

  Properties:
    DGConnectIdentifier             = 'BDG'
    ObserverConnectIdentifier       = ''
    LogXptMode                      = 'ASYNC'
    DelayMins                       = '0'
    Binding                         = 'optional'
    MaxFailure                      = '0'
    MaxConnections                  = '1'
    ReopenSecs                      = '300'
    NetTimeout                      = '30'
    RedoCompression                 = 'DISABLE'
    LogShipping                     = 'ON'
    PreferredApplyInstance          = ''
    ApplyInstanceTimeout            = '0'
    ApplyParallel                   = 'AUTO'
    StandbyFileManagement           = 'AUTO'
    ArchiveLagTarget                = '0'
    LogArchiveMaxProcesses          = '4'
    LogArchiveMinSucceedDest        = '1'
    DbFileNameConvert               = 'jkt, bdg'
    LogFileNameConvert              = 'jkt, bdg'
    FastStartFailoverTarget         = ''
    StatusReport                    = '(monitor)'
    InconsistentProperties          = '(monitor)'
    InconsistentLogXptProps         = '(monitor)'
    SendQEntries                    = '(monitor)'
    LogXptStatus                    = '(monitor)'
    RecvQEntries                    = '(monitor)'
    HostName                        = 'bandung.indonesia.com'
    SidName                         = 'bdg'
    StaticConnectIdentifier         = '(DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1521))(CONNECT_DATA=(SERVICE_NAME=BDG_DGMGRL)(INSTANCE_NAME=bdg)(SERVER=DEDICATED)))'
    StandbyArchiveLocation          = '/home/oracle/oradb/product/11.2.0/dbhome_1/dbs/ARCHIVELOG/'
    AlternateLocation               = ''
    LogArchiveTrace                 = '0'
    LogArchiveFormat                = '%t_%s_%r.arc'
    TopWaitEvents                   = '(monitor)'

Database Status:
SUCCESS

DGMGRL> SHOW DATABASE VERBOSE 'JKT'

Database - JKT

  Role:            PHYSICAL STANDBY
  Intended State:  APPLY-ON
  Transport Lag:   0 seconds
  Apply Lag:       0 seconds
  Real Time Query: OFF
  Instance(s):
    jkt

  Properties:
    DGConnectIdentifier             = 'JKT'
    ObserverConnectIdentifier       = ''
    LogXptMode                      = 'SYNC'
    DelayMins                       = '0'
    Binding                         = 'OPTIONAL'
    MaxFailure                      = '0'
    MaxConnections                  = '1'
    ReopenSecs                      = '300'
    NetTimeout                      = '30'
    RedoCompression                 = 'DISABLE'
    LogShipping                     = 'ON'
    PreferredApplyInstance          = ''
    ApplyInstanceTimeout            = '0'
    ApplyParallel                   = 'AUTO'
    StandbyFileManagement           = 'AUTO'
    ArchiveLagTarget                = '0'
    LogArchiveMaxProcesses          = '4'
    LogArchiveMinSucceedDest        = '1'
    DbFileNameConvert               = 'bdg, jkt'
    LogFileNameConvert              = 'bdg, jkt'
    FastStartFailoverTarget         = ''
    StatusReport                    = '(monitor)'
    InconsistentProperties          = '(monitor)'
    InconsistentLogXptProps         = '(monitor)'
    SendQEntries                    = '(monitor)'
    LogXptStatus                    = '(monitor)'
    RecvQEntries                    = '(monitor)'
    HostName                        = 'jakarta.indonesia.com'
    SidName                         = 'jkt'
    StaticConnectIdentifier         = '(DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1521))(CONNECT_DATA=(SERVICE_NAME=JKT_DGMGRL)(INSTANCE_NAME=jkt)(SERVER=DEDICATED)))'
    StandbyArchiveLocation          = '/home/oracle/oradb/product/11.2.0/dbhome_1/dbs/ARCHIVELOG/'
    AlternateLocation               = ''
    LogArchiveTrace                 = '0'
    LogArchiveFormat                = '%t_%s_%r.arc'
    TopWaitEvents                   = '(monitor)'

Database Status:
SUCCESS

DGMGRL> EDIT DATABASE 'BDG' SET PROPERTY 'LogXptMode'='SYNC';
Property "LogXptMode" updated
DGMGRL> SHOW DATABASE VERBOSE 'BDG'

Database - BDG

  Role:            PRIMARY
  Intended State:  TRANSPORT-ON
  Instance(s):
    bdg

  Properties:
    DGConnectIdentifier             = 'BDG'
    ObserverConnectIdentifier       = ''
    LogXptMode                      = 'SYNC'
    DelayMins                       = '0'
    Binding                         = 'optional'
    MaxFailure                      = '0'
    MaxConnections                  = '1'
    ReopenSecs                      = '300'
    NetTimeout                      = '30'
    RedoCompression                 = 'DISABLE'
    LogShipping                     = 'ON'
    PreferredApplyInstance          = ''
    ApplyInstanceTimeout            = '0'
    ApplyParallel                   = 'AUTO'
    StandbyFileManagement           = 'AUTO'
    ArchiveLagTarget                = '0'
    LogArchiveMaxProcesses          = '4'
    LogArchiveMinSucceedDest        = '1'
    DbFileNameConvert               = 'jkt, bdg'
    LogFileNameConvert              = 'jkt, bdg'
    FastStartFailoverTarget         = ''
    StatusReport                    = '(monitor)'
    InconsistentProperties          = '(monitor)'
    InconsistentLogXptProps         = '(monitor)'
    SendQEntries                    = '(monitor)'
    LogXptStatus                    = '(monitor)'
    RecvQEntries                    = '(monitor)'
    HostName                        = 'bandung.indonesia.com'
    SidName                         = 'bdg'
    StaticConnectIdentifier         = '(DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1521))(CONNECT_DATA=(SERVICE_NAME=BDG_DGMGRL)(INSTANCE_NAME=bdg)(SERVER=DEDICATED)))'
    StandbyArchiveLocation          = '/home/oracle/oradb/product/11.2.0/dbhome_1/dbs/ARCHIVELOG/'
    AlternateLocation               = ''
    LogArchiveTrace                 = '0'
    LogArchiveFormat                = '%t_%s_%r.arc'
    TopWaitEvents                   = '(monitor)'

Database Status:
SUCCESS

DGMGRL>

jakarta.indonesia.com
---------------------
Prim: JKT
Stby: BDG

[oracle@jakarta ~]$ rlwrap dgmgrl
DGMGRL for Linux: Version 11.2.0.1.0 - 64bit Production

Copyright (c) 2000, 2009, Oracle. All rights reserved.

Welcome to DGMGRL, type "help" for information.
DGMGRL> connect sys/oracle789
Connected.
DGMGRL> SHOW CONFIGURATION

Configuration - KotaDR

  Protection Mode: MaxPerformance
  Databases:
    JKT - Primary database
    BDG - Physical standby database

Fast-Start Failover: DISABLED

Configuration Status:
SUCCESS

DGMGRL> SHOW DATABASE VERBOSE 'JKT'

Database - JKT

  Role:            PRIMARY
  Intended State:  TRANSPORT-ON
  Instance(s):
    jkt

  Properties:
    DGConnectIdentifier             = 'JKT'
    ObserverConnectIdentifier       = ''
    LogXptMode                      = 'SYNC'
    DelayMins                       = '0'
    Binding                         = 'OPTIONAL'
    MaxFailure                      = '0'
    MaxConnections                  = '1'
    ReopenSecs                      = '300'
    NetTimeout                      = '30'
    RedoCompression                 = 'DISABLE'
    LogShipping                     = 'ON'
    PreferredApplyInstance          = ''
    ApplyInstanceTimeout            = '0'
    ApplyParallel                   = 'AUTO'
    StandbyFileManagement           = 'AUTO'
    ArchiveLagTarget                = '0'
    LogArchiveMaxProcesses          = '4'
    LogArchiveMinSucceedDest        = '1'
    DbFileNameConvert               = 'bdg, jkt'
    LogFileNameConvert              = 'bdg, jkt'
    FastStartFailoverTarget         = ''
    StatusReport                    = '(monitor)'
    InconsistentProperties          = '(monitor)'
    InconsistentLogXptProps         = '(monitor)'
    SendQEntries                    = '(monitor)'
    LogXptStatus                    = '(monitor)'
    RecvQEntries                    = '(monitor)'
    HostName                        = 'jakarta.indonesia.com'
    SidName                         = 'jkt'
    StaticConnectIdentifier         = '(DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1521))(CONNECT_DATA=(SERVICE_NAME=JKT_DGMGRL)(INSTANCE_NAME=jkt)(SERVER=DEDICATED)))'
    StandbyArchiveLocation          = '/home/oracle/oradb/product/11.2.0/dbhome_1/dbs/ARCHIVELOG/'
    AlternateLocation               = ''
    LogArchiveTrace                 = '0'
    LogArchiveFormat                = '%t_%s_%r.arc'
    TopWaitEvents                   = '(monitor)'

Database Status:
SUCCESS

DGMGRL> SWITCHOVER TO 'BDG'
Performing switchover NOW, please wait...
New primary database "BDG" is opening...
Operation requires shutdown of instance "jkt" on database "JKT"
Shutting down instance "jkt"...
ORA-01109: database not open

Database dismounted.
ORACLE instance shut down.
Operation requires startup of instance "jkt" on database "JKT"
Starting instance "jkt"...
Unable to connect to database
ORA-12514: TNS:listener does not currently know of service requested in connect descriptor

Failed.
Warning: You are no longer connected to ORACLE.

Please complete the following steps to finish switchover:
        start up and mount instance "jkt" of database "JKT"

DGMGRL>

SQL> CONN SYS/oracle789 as sysdba
Connected to an idle instance.
SQL> STARTUP MOUNT;
ORACLE instance started.

Total System Global Area  622149632 bytes
Fixed Size                  2215904 bytes
Variable Size             398458912 bytes
Database Buffers          213909504 bytes
Redo Buffers                7565312 bytes
Database mounted.
SQL> !ps -ef|grep mrp
oracle    6325     1 15 12:55 ?        00:00:01 ora_mrp0_jkt
oracle    6333  5830  0 12:55 pts/1    00:00:00 /bin/bash -c ps -ef|grep mrp
oracle    6335  6333  0 12:55 pts/1    00:00:00 grep mrp

SQL>

DGMGRL> connect SYS/oracle789
Connected.
DGMGRL> show configuration

Configuration - KotaDR

  Protection Mode: MaxPerformance
  Databases:
    BDG - Primary database
    JKT - Physical standby database

Fast-Start Failover: DISABLED

Configuration Status:
SUCCESS

DGMGRL>

bandung.indonesia.com
---------------------
SQL> conn sys/oracle789 as sysdba
Connected.
SQL> archive log list;
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            /home/oracle/oradb/product/11.2.0/dbhome_1/dbs/ARCHIVELOG/
Oldest online log sequence     47
Next log sequence to archive   49
Current log sequence           49
SQL> ALTER SYSTEM SWITCH LOGFILE;

System altered.

Elapsed: 00:00:00.89
SQL> archive log list;
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            /home/oracle/oradb/product/11.2.0/dbhome_1/dbs/ARCHIVELOG/
Oldest online log sequence     48
Next log sequence to archive   50
Current log sequence           50
SQL>

jakarta.indonesia.com
---------------------
SQL> ARCHIVE LOG LIST;
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            /home/oracle/oradb/product/11.2.0/dbhome_1/dbs/ARCHIVELOG/
Oldest online log sequence     49
Next log sequence to archive   0
Current log sequence           50
SQL> SELECT al.thrd "Thread", almax "Last Seq Received", lhmax "Last Seq Applied" FROM (select thread# thrd, MAX(sequence#) almax FROM v$archived_log WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) GROUP BY thread#) al, (SELECT thread# thrd, MAX(sequence#) lhmax FROM v$log_history WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) GROUP BY thread#) lh WHERE al.thrd = lh.thrd;

    Thread Last Seq Received Last Seq Applied
---------- ----------------- ----------------
         1                49               49

Elapsed: 00:00:00.02
SQL>