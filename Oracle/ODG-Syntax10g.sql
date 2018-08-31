/*
Performing Switchover in a Data Guard Configuration
Subject: Performing Switchover in a Data Guard Configuration 
Doc ID: Note:232240.1 Type: BULLETIN 
Last Revision Date: 10-NOV-2003 Status: PUBLISHED 


Overview
---------------

A switchover is a role reversal between the primary database and one of its standby
databases. A switchover operation guarantees no data loss. This is typically done
for planned maintenance of the primary system. During a switchover, the primary 
database transitions to a standby role and the standby database transitions to 
the primary role. The transition occurs without having to re-create either 
database. 

By contrast, a failover is an irreversible transition of a standby database to 
the primary role. This is only done in the event of a catastrophic failure of 
the primary database.


Before starting a switchover operation:
------------------------------------------- 

1. Verify that both the primary and standby init.ora support role transition. 
Oracle recommends that you maintain a single init.ora for both the primary
and the standby. Each init.ora should have all the parameters that are needed
to support either the standby or primary role. An example of the primary
init.ora follows:

-- snip ---

### Primary database primary role parameterr ###

LOG_ARCHIVE_DEST_1='LOCATION=/database/oracle/920DG/primary/arch'
LOG_ARCHIVE_DEST_2='SERVICE=920DG_hasunclu2'
LOG_ARCHIVE_DEST_STATE_1=ENABLE
LOG_ARCHIVE_DEST_STATE_2=ENABLE
LOG_ARCHIVE_FORMAT=%d_%t_%s.arc

### Primary database standby role parameters ###

FAL_SERVER=920DG_hasunclu2
FAL_CLIENT=920DG_hasunclu1
DB_FILE_NAME_CONVERT=('/standby','/primary') 
LOG_FILE_NAME_CONVERT=('/standby','/primary') 
STANDBY_ARCHIVE_DEST=/database/oracle/920DG/arch
STANDBY_FILE_MANAGEMENT=AUTO

-- snip --

An example of a standby init.ora follows:

-- snip --

### Standby database standby role parameters ###

FAL_SERVER=920DG_hasunclu1
FAL_CLIENT=920DG_hasunclu2
DB_FILE_NAME_CONVERT=("/primary","/standby") 
LOG_FILE_NAME_CONVERT=("/primary","/standby") 
STANDBY_ARCHIVE_DEST=/database/oracle/920DG/standby/arch
LOG_ARCHIVE_DEST_1='LOCATION=/database/oracle/920DG/standby/arch'
LOG_ARCHIVE_DEST_STATE_1=ENABLE
LOG_ARCHIVE_FORMAT=%d_%t_%s.arc
STANDBY_FILE_MANAGEMENT=AUTO

### Standby database primary role parameters ###

LOG_ARCHIVE_DEST_2='SERVICE=920DG_hasunclu1'
LOG_ARCHIVE_DEST_STATE_2=DEFER

-- snip --

With the initialization parameters on both the primary and standby databases
set as described above, the only parameter that needs to change after a role
transition is the LOG_ARCHIVE_DEST_STATE_2 parameter. Change this parameter to
ENABLED on the database that assumes the primary role. 

2. Verify that there is network connectivity between the primary and standby 
locations. 

3. Each location in the Data Guard configuration should have connectivity 
through Oracle Net to the primary database and to all associated standby 
databases. 

4. Verify that there are no active users connected to the databases. 

5. Verify that all but one primary instance and one standby instance in a Real 
Application Clusters configuration are shut down. 

6. For a Real Application Clusters database, only one primary instance and one 
standby instance can perform the switchover operation. Shut down all other 
instances before the switchover operation. 

7. For switchover operations involving a physical standby database, the primary
database instance is open and the standby database instance is mounted. 

8. The standby database that you plan to transition to the primary role must be
mounted before you begin the switchover operation. Ideally, the physical 
standby database will also be actively recovering archived redo logs when 
the database roles are switched. If the physical standby database is open 
for read-only access, the switchover operation still will take place, but 
will require additional time. 

9. For switchover operations involving a logical standby database, both the primary
and standby database instances are open. 

10. Place the standby database that will become the new primary database in 
ARCHIVELOG mode. 

11. Remove any redo data application delay in effect on the standby database.



Steps to perform switchover with Physical Standby databases:
--------------------------------------------------------------

1. Verify that it is possible to perform a switchover operation. On the primary
query the switchover_status column of v$database to verify that switchover
to standby is possible.
*/

SQL> select switchover_status from v$database;

SWITCHOVER_STATUS
------------------
TO STANDBY
/*
In order to perform a switchover all sessions to the database need to be 
disconnected. In version 901 this was a manual process. In version 9.2.0 
this process has been automated with the “with session shutdown” clause 
that has been added to the alter database commit to switchover command. 
If SWITCHOVER_STATUS returns SESSIONS ACTIVE then you should either 
disconnect all sessions manually or when performing step 2 you should append
the “with session shutdown” clause. For example:
*/
SQL> alter database commit to switchover to standby with session shutdown;
/*
Note that the clause also works with the switchover to primary command.

The SWITCHOVER_STATUS column of v$database can have the following values:

NOT ALLOWED - Either this is a standby database and the primary database has
not been switched first, or this is a primary database and there are no standby databases. 

SESSIONS ACTIVE - Indicates that there are active SQL sessions attached to 
the primary or standby database that need to be disconnected before the 
switchover operation is permitted. 

SWITCHOVER PENDING - This is a standby database and the primary database 
switchover request has been received but not processed. 

SWITCHOVER LATENT - The switchover was in pending mode, but did not complete
and went back to the primary database. 

TO PRIMARY - This is a standby database, with no active sessions, that is 
allowed to switch over to a primary database. 

TO STANDBY - This is a primary database, with no active sessions, that is 
allowed to switch over to a standby database. 

RECOVERY NEEDED - This is a standby database that has not received the 
switchover request. 

During normal operations it is acceptable to see the following values for 
SWITCHOVER_STATUS on the primary to be SESSIONS ACTIVE or TO STANDBY. 
During normal operations on the standby it is acceptable to see the values 
of NOT ALLOWED or SESSIONS ACTIVE.

2. Convert the primary database to the new standby:
*/
SQL> alter database commit to switchover to physical standby;

Database altered.
/*
3. Shutdown the former primary and mount as a standby database:
*/
SQL> shutdown immediate
ORA-01507: database not mounted


ORACLE instance shut down.
SQL> startup nomount
ORACLE instance started.

Total System Global Area 85020944 bytes
Fixed Size 454928 bytes
Variable Size 71303168 bytes
Database Buffers 12582912 bytes
Redo Buffers 679936 bytes
SQL> alter database mount standby database;

Database altered.
/*
4. Defer the remote archive destination on the old primary:
*/
SQL> alter system set log_archive_dest_state_2=defer;
/*
5. Verify that the physical standby can be converted to the new primary:
*/
SQL> select switchover_status from v$database;

SWITCHOVER_STATUS
------------------
SWITCHOVER PENDING 
/*
Note that if the status returns SESSIONS ACTIVE then you should append the 
with session shutdown clause to the command in step 6.


6. Convert the physical standby to the new primary:
*/
SQL> alter database commit to switchover to primary;

Database altered.
/*
If you are on verion 9.0.1 then you should first cancel managed recovery prior
to issuing the above command. If you are on 9.2.0 and have started managed
recovery with the "through all switchover" clause then you should also cancel
managed recovery before issuing the above command.

7. Shutdown and startup the new primary:
*/
SQL> shutdown immediate
ORA-01507: database not mounted


ORACLE instance shut down.
SQL> startup
ORACLE instance started.

Total System Global Area 85020944 bytes
Fixed Size 454928 bytes
Variable Size 71303168 bytes
Database Buffers 12582912 bytes
Redo Buffers 679936 bytes
Database mounted.
Database opened.
SQL>
/*
8. Enable remote archiving on the new primary to the new standby:
*/
SQL> alter system set log_archive_dest_state_2=enable;
/*
9. Start managed recover on the new standby database:
*/
SQL> recover managed standby database disconnect;
Media recovery complete.
SQL> 

/*
Steps to perform switchover with Logical Standby databases:
--------------------------------------------------------------

Note that the SWITCHOVER_STATUS column of the V$DATABASE view is supported only
for use with physical standby databases.

1. Switch the primary database to the logical standby database role.
*/
SQL> alter database commit to switchover to logical standby;

Database altered.
/*
2. Stop the old primary database from shipping archive logs to the logical
standby:
*/
SQL> alter system set log_archive_dest_state_2=defer scope=both;

System altered.
/*
3. Switch the logical standby database to the primary database role:
*/
SQL> alter database commit to switchover to primary; 

Database altered.
/*
4. Enable archiving from the new primary to the new logical standby
*/
SQL> alter system set log_archive_dest_state_2=enable scope=both;

System altered.
/*
5. On each logical standby database, create a database link that points to
the new primary database. (The example in this step uses the database link
location1.) 

Use the DBMS_LOGSTDBY.GUARD_BYPASS_ON procedure to bypass the database guard
and allow modifications to the tables in the logical standby database. For 
example: 
*/
SQL> EXECUTE DBMS_LOGSTDBY.GUARD_BYPASS_ON;
SQL> CREATE DATABASE LINK location1 
2> CONNECT TO user-name IDENTIFIED BY password USING 'location1';
SQL> EXECUTE DBMS_LOGSTDBY.GUARD_BYPASS_OFF;
/*
6. On the new logical standby database (formerly the primary database) and on 
any other existing logical standby destinations, begin SQL apply operations: 
*/
SQL> ALTER DATABASE START LOGICAL STANDBY APPLY NEW PRIMARY location1; 
/*
7. On the new primary database, enable archive logging and switch logs to ensure
that all the standby databases begin receiving redo logs by executing the 
following SQL statements: 
*/
SQL> ALTER SYSTEM ARCHIVE LOG START;
SQL> ALTER SYSTEM SWITCH LOGFILE;