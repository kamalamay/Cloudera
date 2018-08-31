SNAPSHOT STANDBY
----------------
SQL> SELECT DB_UNIQUE_NAME,DATABASE_ROLE FROM V$DATABASE;

DB_UNIQUE_NAME		       DATABASE_ROLE
------------------------------ ----------------
JKT			       PHYSICAL STANDBY

Elapsed: 00:00:00.01

DGMGRL> show configuration

Configuration - KotaDR

  Protection Mode: MaxPerformance
  Databases:
    BDG - Primary database
    JKT - Physical standby database

Fast-Start Failover: DISABLED

Configuration Status:
SUCCESS

DGMGRL> CONVERT DATABASE 'JKT' TO SNAPSHOT STANDBY;
Converting database "JKT" to a Snapshot Standby database, please wait...
Database "JKT" converted successfully
DGMGRL> show configuration

Configuration - KotaDR

  Protection Mode: MaxPerformance
  Databases:
    BDG - Primary database
    JKT - Snapshot standby database

Fast-Start Failover: DISABLED

Configuration Status:
SUCCESS

DGMGRL>

SQL> SELECT DB_UNIQUE_NAME,DATABASE_ROLE FROM V$DATABASE;

DB_UNIQUE_NAME		       DATABASE_ROLE
------------------------------ ----------------
JKT			       SNAPSHOT STANDBY

Elapsed: 00:00:00.01
SQL>

PHYSICAL STANDBY
----------------
DGMGRL> CONVERT DATABASE 'JKT' TO PHYSICAL STANDBY;
Converting database "JKT" to a Physical Standby database, please wait...
Operation requires shutdown of instance "jkt" on database "JKT"
Shutting down instance "jkt"...
Database closed.
Database dismounted.
ORACLE instance shut down.
Operation requires startup of instance "jkt" on database "JKT"
Starting instance "jkt"...
ORACLE instance started.
Database mounted.
Continuing to convert database "JKT" ...
Operation requires shutdown of instance "jkt" on database "JKT"
Shutting down instance "jkt"...
ORA-01109: database not open

Database dismounted.
ORACLE instance shut down.
Operation requires startup of instance "jkt" on database "JKT"
Starting instance "jkt"...
ORACLE instance started.
Database mounted.
Database "JKT" converted successfully
DGMGRL> SHOW CONFIGURATION

Configuration - KotaDR

  Protection Mode: MaxPerformance
  Databases:
    BDG - Primary database
    JKT - Physical standby database

Fast-Start Failover: DISABLED

Configuration Status:
SUCCESS

DGMGRL>

SQL> SELECT DB_UNIQUE_NAME,DATABASE_ROLE FROM V$DATABASE;

DB_UNIQUE_NAME		       DATABASE_ROLE
------------------------------ ----------------
JKT			       PHYSICAL STANDBY

Elapsed: 00:00:00.01
SQL>