/*
Source: http://emrebaransel.blogspot.fi/2008/08/dataguard-switchover-guide-physical_09.html
*/
--QUICK GUIDE

--old primary site
SQL>select switchover_status from v$database;
SQL>alter database commit to switchover to physical standby with session shutdown;
SQL>shutdown immediate
SQL>startup nomount
SQL>alter database mount standby database;
SQL>alter system set log_archive_dest_state_2=defer;

--old standby site
SQL>select switchover_status from v$database;
SQL>alter database commit to switchover to primary;
SQL>shutdown immediate
SQL>startup

--old primary site
SQL>recover managed standby database disconnect


--EXPLANATIONS

/*
1. Verify that it is possible to perform a switchover operation.

On the primary query the switchover_status column of v$database to verify that
switchover to standby is possible.
*/
SQL> select switchover_status from v$database;

SWITCHOVER_STATUS
------------------
TO STANDBY
/*
In order to perform a switchover all sessions to the database need to be disconnected. This process has been automated with the “with session shutdown” clause that has been added to the alter database commit to switchover command.
If SWITCHOVER_STATUS returns SESSIONS ACTIVE then you should either disconnect all sessions manually or when performing step 2 you should append the “with session shutdown” clause.

For example:
*/
SQL> alter database commit to switchover to standby with session shutdown;
/*
Note that the clause also works with the switchover to primary command.

The SWITCHOVER_STATUS column of v$database can have the following values:

NOT ALLOWED - Either this is a standby database and the primary database has not been switched first, or this is a primary database and there are no standby databases.

SESSIONS ACTIVE - Indicates that there are active SQL sessions attached to the primary or standby database that need to be disconnected before the switchover operation is permitted.

SWITCHOVER PENDING - This is a standby database and the primary database switchover request has been received but not processed.

SWITCHOVER LATENT - The switchover was in pending mode, but did not complete and went back to the primary database.

TO PRIMARY - This is a standby database, with no active sessions, that is allowed to switch over to a primary database.

TO STANDBY - This is a primary database, with no active sessions, that is allowed to switch over to a standby database.

RECOVERY NEEDED - This is a standby database that has not received the switchover request.

During normal operations it is acceptable to see the following values for
SWITCHOVER_STATUS on the primary to be SESSIONS ACTIVE or TO STANDBY.

During normal operations on the standby it is acceptable to see the values of
NOT ALLOWED or SESSIONS ACTIVE.


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
SQL> alter system set log_archive_dest_state_3=defer;
/*
5. Verify that the physical standby can be converted to the new primary:
*/
SQL> select switchover_status from v$database;

SWITCHOVER_STATUS
------------------
SWITCHOVER PENDING
/*
Note that if the status returns SESSIONS ACTIVE then you should append the with session shutdown clause to the command in step 6.

6. Convert the physical standby to the new primary:
*/
SQL> alter database commit to switchover to primary;

Database altered.
/*
7. Shutdown and startup the new primary:
*/
SQL> shutdown immediate

ORA-01507: database not mounted
ORACLE instance shut down.

SQL> startup;

ORACLE instance started.
Total System Global Area 85020944 bytes
Fixed Size 454928 bytes
Variable Size 71303168 bytes
Database Buffers 12582912 bytes
Redo Buffers 679936 bytes
Database mounted.
Database opened.
/*
8. Enable remote archiving on the new primary to the new standby:
*/
SQL> alter system set log_archive_dest_state_3=enable;
/*
9. Start managed recover on the new standby database:
*/
SQL> recover managed standby database disconnect;

Media recovery complete.
