/*Hati-hati dengan tidak sampainya logfile*/
JKT
---
SQL> SELECT SWITCHOVER_STATUS FROM V$DATABASE;

SWITCHOVER_STATUS
--------------------
TO STANDBY

SQL> SHOW PARAMETER DEST_2;

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
db_create_online_log_dest_2	     string
log_archive_dest_2		     string	 service=172.16.45.102:1521/bdg async valid_for=(online_logfiles,primary_role) db_unique_name=bdg
log_archive_dest_20		     string
log_archive_dest_21		     string
log_archive_dest_22		     string
log_archive_dest_23		     string
log_archive_dest_24		     string
log_archive_dest_25		     string
log_archive_dest_26		     string
log_archive_dest_27		     string
log_archive_dest_28		     string
log_archive_dest_29		     string
SQL> SHOW PARAMETER STATE_2;

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
log_archive_dest_state_2	     string	 ENABLE
log_archive_dest_state_20	     string	 enable
log_archive_dest_state_21	     string	 enable
log_archive_dest_state_22	     string	 enable
log_archive_dest_state_23	     string	 enable
log_archive_dest_state_24	     string	 enable
log_archive_dest_state_25	     string	 enable
log_archive_dest_state_26	     string	 enable
log_archive_dest_state_27	     string	 enable
log_archive_dest_state_28	     string	 enable
log_archive_dest_state_29	     string	 enable
SQL> SELECT * FROM V$ARCHIVE_GAP;

no rows selected

SQL> SELECT THREAD#, SEQUENCE#, ARCHIVED, APPLIED, STATUS FROM V$ARCHIVED_LOG ORDER BY 2;

   THREAD#  SEQUENCE# ARC APPLIED   S
---------- ---------- --- --------- -
	 1	    5 YES NO	    A
	 1	    6 YES NO	    A
	 1	    7 YES NO	    A
	 1	    7 YES YES	    A
	 1	    8 YES YES	    A
	 1	    8 YES NO	    A
	 1	    9 YES NO	    A
	 1	    9 YES YES	    A
	 1	   10 YES NO	    A
	 1	   10 YES YES	    A
	 1	   11 YES NO	    A
	 1	   11 YES YES	    A
	 1	   12 YES YES	    A
	 1	   12 YES NO	    A
	 1	   13 YES YES	    A
	 1	   13 YES NO	    A
	 1	   14 YES YES	    A
	 1	   14 YES NO	    A
	 1	   15 YES YES	    A
	 1	   15 YES NO	    A
	 1	   16 YES NO	    A
	 1	   16 YES YES	    A
	 1	   17 YES YES	    A
	 1	   17 YES NO	    A
	 1	   18 YES NO	    A
	 1	   18 YES YES	    A
	 1	   19 YES NO	    A
	 1	   19 YES YES	    A
	 1	   20 YES NO	    A
	 1	   20 YES YES	    A
	 1	   21 YES NO	    A
	 1	   21 YES YES	    A
	 1	   22 YES NO	    A
	 1	   22 YES YES	    A
	 1	   23 YES NO	    A
	 1	   23 YES YES	    A
	 1	   24 YES YES	    A
	 1	   24 YES NO	    A
	 1	   25 YES YES	    A
	 1	   25 YES NO	    A
	 1	   26 YES NO	    A
	 1	   26 YES YES	    A
	 1	   27 YES YES	    A
	 1	   27 YES NO	    A

44 rows selected.

SQL> SELECT SWITCHOVER_STATUS FROM V$DATABASE;

SWITCHOVER_STATUS
--------------------
TO STANDBY

SQL> ALTER DATABASE COMMIT TO SWITCHOVER TO PHYSICAL STANDBY WITH SESSION SHUTDOWN;

Database altered.

SQL> SHUTDOWN IMMEDIATE;
ORA-01507: database not mounted


ORACLE instance shut down.
SQL> STARTUP NOMOUNT;
ORACLE instance started.

Total System Global Area  622149632 bytes
Fixed Size		    2215904 bytes
Variable Size		  406847520 bytes
Database Buffers	  205520896 bytes
Redo Buffers		    7565312 bytes
SQL> ALTER DATABASE MOUNT STANDBY DATABASE;

Database altered.

SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=DEFER;

System altered.

SQL> 

---
BDG
---
[oracle@ora02 ~]$ rlwrap sqlplus sys as sysdba

SQL*Plus: Release 11.2.0.1.0 Production on Thu May 8 15:21:19 2014

Copyright (c) 1982, 2009, Oracle.  All rights reserved.

Enter password: 

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

SQL> SELECT SWITCHOVER_STATUS FROM V$DATABASE;

SWITCHOVER_STATUS
--------------------
TO PRIMARY

SQL> ALTER DATABASE COMMIT TO SWITCHOVER TO PRIMARY;

Database altered.

SQL> SHUTDOWN IMMEDIATE;
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.
SQL> STARTUP;
ORACLE instance started.

Total System Global Area  217157632 bytes
Fixed Size		    2211928 bytes
Variable Size		  159387560 bytes
Database Buffers	   50331648 bytes
Redo Buffers		    5226496 bytes
Database mounted.
Database opened.
SQL> 

---
JKT
---
SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=ENABLE;

System altered.

SQL> recover managed standby database disconnect from session;
Media recovery complete.
SQL> 