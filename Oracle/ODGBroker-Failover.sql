FAILOVER
--------
bandung.indonesia.com
---------------------
DGMGRL> SHOW CONFIGURATION

Configuration - KotaDR

  Protection Mode: MaxPerformance
  Databases:
    BDG - Primary database
    JKT - Physical standby database

Fast-Start Failover: DISABLED

Configuration Status:
SUCCESS

DGMGRL> FAILOVER TO 'JKT'
Performing failover NOW, please wait...
Error: ORA-16600: not connected to target standby database for failover

Failed.
Unable to failover
DGMGRL>

alert_bdg.log
-------------
Fri Feb 17 22:19:01 2017
DMON: Failover rejected, error = ORA-16600

jakarta.indonesia.com
---------------------
DGMGRL> FAILOVER TO 'JKT';
Performing failover NOW, please wait...
Failover succeeded, new primary is "JKT"
DGMGRL> SHOW CONFIGURATION

Configuration - KotaDR

  Protection Mode: MaxPerformance
  Databases:
    JKT - Primary database
    BDG - Physical standby database (disabled)
      ORA-16661: the standby database needs to be reinstated

Fast-Start Failover: DISABLED

Configuration Status:
SUCCESS

DGMGRL>

SQL> SELECT DB_UNIQUE_NAME,OPEN_MODE,DATABASE_ROLE FROM V$DATABASE;

DB_UNIQUE_NAME		       OPEN_MODE	    DATABASE_ROLE
------------------------------ -------------------- ----------------
JKT			       READ WRITE	    PRIMARY

Elapsed: 00:00:00.01
SQL>

SQL> SELECT DB_UNIQUE_NAME,OPEN_MODE,DATABASE_ROLE FROM V$DATABASE;

DB_UNIQUE_NAME		       OPEN_MODE	    DATABASE_ROLE
------------------------------ -------------------- ----------------
BDG			       READ WRITE	    PRIMARY

Elapsed: 00:00:00.01
SQL>

REINSTATE AFTER FAILOVER
------------------------
SQL> SHU IMMEDIATE;
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> STARTUP MOUNT;
ORACLE instance started.

Total System Global Area  217157632 bytes
Fixed Size		    2211928 bytes
Variable Size		  159387560 bytes
Database Buffers	   50331648 bytes
Redo Buffers		    5226496 bytes
Database mounted.
SQL> SELECT DB_UNIQUE_NAME,OPEN_MODE,DATABASE_ROLE FROM V$DATABASE;

DB_UNIQUE_NAME		       OPEN_MODE	    DATABASE_ROLE
------------------------------ -------------------- ----------------
BDG			       MOUNTED		    PRIMARY

Elapsed: 00:00:00.02
SQL>