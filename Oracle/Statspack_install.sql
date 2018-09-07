[prastyo.AzizPW] ➤ /media/d/vmware/OEL7-11.2.0.4.0/ssh.sh
Last login: Mon Jan 11 13:22:09 2016
[orekel@pitik ~]$ rlwrap sqlplus sys as sysdba

SQL*Plus: Release 11.2.0.4.0 Production on Mon Jan 11 13:25:04 2016

Copyright (c) 1982, 2013, Oracle.  All rights reserved.

Enter password:
Connected to an idle instance.

SQL> startup;
ORACLE instance started.

Total System Global Area  613855232 bytes
Fixed Size                  2255592 bytes
Variable Size             272631064 bytes
Database Buffers          331350016 bytes
Redo Buffers                7618560 bytes
Database mounted.
Database opened.
SQL> EXEC STATSPACK.SNAP();
BEGIN STATSPACK.SNAP(); END;

      *
ERROR at line 1:
ORA-06550: line 1, column 7:
PLS-00201: identifier 'STATSPACK.SNAP' must be declared
ORA-06550: line 1, column 7:
PL/SQL: Statement ignored


SQL> CREATE TABLESPACE PERFSTAT DATAFILE '/mp03/oradata-ayam/perfstat01.dbf' size 128M;

Tablespace created.

Elapsed: 00:00:03.77
SQL> @?/rdbms/admin/spcreate

Choose the PERFSTAT user's password
-----------------------------------
Not specifying a password will result in the installation FAILING

Enter value for perfstat_password: perfstat
perfstat
Elapsed: 00:00:00.00


Choose the Default tablespace for the PERFSTAT user
---------------------------------------------------
Below is the list of online tablespaces in this database which can
store user data.  Specifying the SYSTEM tablespace for the user's
default tablespace will result in the installation FAILING, as
using SYSTEM for performance data is not supported.

Choose the PERFSTAT users's default tablespace.  This is the tablespace
in which the STATSPACK tables and indexes will be created.

TABLESPACE_NAME                CONTENTS  STATSPACK DEFAULT TABLESPACE
------------------------------ --------- ----------------------------
EXAMPLE                        PERMANENT
PERFSTAT                       PERMANENT
SYSAUX                         PERMANENT *
USERS                          PERMANENT
USERS_IX                       PERMANENT
Elapsed: 00:00:00.02

Pressing <return> will result in STATSPACK's recommended default
tablespace (identified by *) being used.

Enter value for default_tablespace: PERFSTAT

Using tablespace PERFSTAT as PERFSTAT default tablespace.
Elapsed: 00:00:00.00
Elapsed: 00:00:00.00


Choose the Temporary tablespace for the PERFSTAT user
-----------------------------------------------------
Below is the list of online tablespaces in this database which can
store temporary data (e.g. for sort workareas).  Specifying the SYSTEM
tablespace for the user's temporary tablespace will result in the
installation FAILING, as using SYSTEM for workareas is not supported.

Choose the PERFSTAT user's Temporary tablespace.

TABLESPACE_NAME                CONTENTS  DB DEFAULT TEMP TABLESPACE
------------------------------ --------- --------------------------
TEMP                           TEMPORARY *
Elapsed: 00:00:00.01

Pressing <return> will result in the database's default Temporary
tablespace (identified by *) being used.

Enter value for temporary_tablespace: TEMP

Using tablespace TEMP as PERFSTAT temporary tablespace.
Elapsed: 00:00:00.01
Elapsed: 00:00:00.00


... Creating PERFSTAT user
Elapsed: 00:00:00.08
Elapsed: 00:00:00.02


... Installing required packages
Elapsed: 00:00:00.06
Elapsed: 00:00:00.03


... Creating views
Elapsed: 00:00:00.12
Elapsed: 00:00:00.08
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.02
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.02
Elapsed: 00:00:00.01
Elapsed: 00:00:00.06
Elapsed: 00:00:00.00
Elapsed: 00:00:00.02
Elapsed: 00:00:00.00


... Granting privileges
Elapsed: 00:00:00.01
Elapsed: 00:00:00.00
Elapsed: 00:00:00.00
Elapsed: 00:00:00.01
Elapsed: 00:00:00.00
Elapsed: 00:00:00.01
Elapsed: 00:00:00.00
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.00
Elapsed: 00:00:00.01
Elapsed: 00:00:00.00
Elapsed: 00:00:00.03
Elapsed: 00:00:00.01
Elapsed: 00:00:00.00
Elapsed: 00:00:00.01
Elapsed: 00:00:00.03
Elapsed: 00:00:00.00
Elapsed: 00:00:00.01
Elapsed: 00:00:00.02
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.00
Elapsed: 00:00:00.02
Elapsed: 00:00:00.00
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.02
Elapsed: 00:00:00.03
Elapsed: 00:00:00.01
Elapsed: 00:00:00.02
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.02
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.03
Elapsed: 00:00:00.03
Elapsed: 00:00:00.03
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.11
Elapsed: 00:00:00.03
Elapsed: 00:00:00.01
Elapsed: 00:00:00.03
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.02
Elapsed: 00:00:00.02
Elapsed: 00:00:00.02
Elapsed: 00:00:00.01
Elapsed: 00:00:00.02
Elapsed: 00:00:00.02
Elapsed: 00:00:00.11
Elapsed: 00:00:00.03
Elapsed: 00:00:00.03
Elapsed: 00:00:00.02
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.02
Elapsed: 00:00:00.01
Elapsed: 00:00:00.00
Elapsed: 00:00:00.02
Elapsed: 00:00:00.00
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.01
Elapsed: 00:00:00.02
Elapsed: 00:00:00.01
Elapsed: 00:00:00.02
Elapsed: 00:00:00.00
Elapsed: 00:00:00.02
Elapsed: 00:00:00.00
Elapsed: 00:00:00.01

NOTE:
SPCUSR complete. Please check spcusr.lis for any errors.

SQL>
SQL> --
SQL> --  Build the tables and synonyms
SQL> connect perfstat/&&perfstat_password
Connected.
SQL> @@spctab
SQL> Rem
SQL> Rem $Header: rdbms/admin/spctab.sql /st_rdbms_11.2.0/3 2012/03/06 15:07:48 shsong Exp $
SQL> Rem
SQL> Rem spctab.sql
SQL> Rem
SQL> Rem Copyright (c) 1999, 2012, Oracle and/or its affiliates.
SQL> Rem All rights reserved.
SQL> Rem
SQL> Rem    NAME
SQL> Rem         spctab.sql
SQL> Rem
SQL> Rem    DESCRIPTION
SQL> Rem         SQL*PLUS command file to create tables to hold
SQL> Rem         start and end "snapshot" statistical information
SQL> Rem
SQL> Rem    NOTES
SQL> Rem         Should be run as STATSPACK user, PERFSTAT
SQL> Rem
SQL> Rem    MODIFIED   (MM/DD/YY)
SQL> Rem    kchou       08/11/10 - Bug#9800868 - Add Missing Idle Events for
SQL> Rem                           11.2.0.2for Statspack & Standby Statspack
SQL> Rem    kchou       08/11/10 - Bug#9800868 - Add missing idle events to 11.2.0.2
SQL> Rem    cgervasi    05/13/09 - add idle event: cell worker idle
SQL> Rem    cgervasi    04/02/09 - bug8395154: missing idle events
SQL> Rem    rhlee       02/22/08 -
> Rem    cdgreen     03/14/07 - 11 F2
SQL> Rem    shsong      06/14/07 - Add idle events
SQL> Rem    cdgreen     02/28/07 - 5908354
SQL> Rem    cdgreen     04/26/06 - 11 F1
SQL> Rem    cdgreen     06/26/06 - Increase column length
SQL> Rem    cdgreen     05/10/06 - 5215982
SQL> Rem    cdgreen     05/24/05 - 4246955
SQL> Rem    cdgreen     04/18/05 - 4228432
SQL> Rem    cdgreen     03/08/05 - 10gR2 misc
SQL> Rem    vbarrier    02/18/05 - 4081984
SQL> Rem    cdgreen     10/29/04 - 10gR2_sqlstats
SQL> Rem    cdgreen     07/16/04 - 10gR2
SQL> Rem    cdialeri    03/25/04 - 3516921
SQL> Rem    vbarrier    02/12/04 - 3412853
SQL> Rem    cdialeri    12/04/03 - 3290482
SQL> Rem    cdialeri    11/05/03 - 3202706
SQL> Rem    cdialeri    10/14/03 - 10g - streams - rvenkate
SQL> Rem    cdialeri    08/05/03 - 10g F3
SQL> Rem    cdialeri    02/27/03 - 10g F2: baseline, purge
SQL> Rem    vbarrier    02/25/03 - 10g RAC
SQL> Rem    cdialeri    11/15/02 - 10g F1
SQL> Rem    cdialeri    09/27/02 - sleep4
SQL> Rem    vbarrier    03/20/02 - 2143634
SQL> Rem    vbarrier    03/05/02 - Segment Statistics
SQL> Rem    cdialeri    02/07/02 - 2218573
SQL> Rem    cdialeri    01/30/02 - 2184717
SQL> Rem    cdialeri    01/11/02 - 9.2 - features 2
SQL> Rem    cdialeri    11/30/01 - 9.2 - features 1
SQL> Rem    cdialeri    04/22/01 - Undostat changes
SQL> Rem    cdialeri    03/02/01 - 9.0
SQL> Rem    cdialeri    09/12/00 - sp_1404195
SQL> Rem    cdialeri    04/07/00 - 1261813
SQL> Rem    cdialeri    03/20/00 - Support for purge
SQL> Rem    cdialeri    02/16/00 - 1191805
SQL> Rem    cdialeri    01/26/00 - 1169401
SQL> Rem    cdialeri    11/01/99 - Enhance, 1059172
SQL> Rem    cmlim       07/17/97 - Added STATS$SQLAREA to store top sql stmts
SQL> Rem    gwood       10/16/95 - Version to run as sys without using many views
SQL> Rem    cellis.uk   11/15/89 - Created
SQL> Rem
SQL>
SQL> set showmode off echo off;

If this script is automatically called from spcreate (which is
the supported method), all STATSPACK segments will be created in
the PERFSTAT user's default tablespace.

Using PERFSTAT tablespace to store Statspack objects

... Creating STATS$SNAPSHOT_ID Sequence

Sequence created.

Elapsed: 00:00:00.06

Synonym created.

Elapsed: 00:00:00.01
... Creating STATS$... tables

Table created.

Elapsed: 00:00:00.21

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.02

1 row created.

Elapsed: 00:00:00.04

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

Commit complete.

Elapsed: 00:00:00.00

Synonym created.

Elapsed: 00:00:00.03

Table created.

Elapsed: 00:00:00.05

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.07

Synonym created.

Elapsed: 00:00:00.03

Table created.

Elapsed: 00:00:00.05

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.06

Synonym created.

Elapsed: 00:00:00.03

Table created.

Elapsed: 00:00:00.08

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.08

Synonym created.

Elapsed: 00:00:00.02

Table created.

Elapsed: 00:00:00.08

Synonym created.

Elapsed: 00:00:00.02

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.02

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.05

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.13

Synonym created.

Elapsed: 00:00:00.05

Table created.

Elapsed: 00:00:00.15

Synonym created.

Elapsed: 00:00:00.08

Table created.

Elapsed: 00:00:00.12

Synonym created.

Elapsed: 00:00:00.10

Table created.

Elapsed: 00:00:00.13

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.09

Synonym created.

Elapsed: 00:00:00.08

Table created.

Elapsed: 00:00:00.10

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.06

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.09

Synonym created.

Elapsed: 00:00:00.02

Table created.

Elapsed: 00:00:00.06

Synonym created.

Elapsed: 00:00:00.02

Table created.

Elapsed: 00:00:00.04

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.04

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.02

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.02

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.07

Index created.

Elapsed: 00:00:00.01

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.02

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.02

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.02

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.04

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.05

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.02

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.02

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.02

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.02

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.04

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.05

Synonym created.

Elapsed: 00:00:00.02

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.02

Table created.

Elapsed: 00:00:00.04

Synonym created.

Elapsed: 00:00:00.02

Table created.

Elapsed: 00:00:00.05

Synonym created.

Elapsed: 00:00:00.02

Table created.

Elapsed: 00:00:00.04

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.04

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.04

Synonym created.

Elapsed: 00:00:00.02

Table created.

Elapsed: 00:00:00.05

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.04

Synonym created.

Elapsed: 00:00:00.02

Table created.

Elapsed: 00:00:00.04

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.02

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.02

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.04

Synonym created.

Elapsed: 00:00:00.01

Table created.

Elapsed: 00:00:00.05

Synonym created.

Elapsed: 00:00:00.00

View created.

Elapsed: 00:00:00.03

Synonym created.

Elapsed: 00:00:00.00

Table created.

Elapsed: 00:00:00.02

1 row created.

Elapsed: 00:00:00.03

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.01

1 row created.

Elapsed: 00:00:00.00

1 row created.

Elapsed: 00:00:00.00

Commit complete.

Elapsed: 00:00:00.00

Synonym created.

Elapsed: 00:00:00.01

Synonym created.

Elapsed: 00:00:00.00

NOTE:
SPCTAB complete. Please check spctab.lis for any errors.

SQL> --  Create the statistics Package
SQL> @@spcpkg
SQL> Rem
SQL> Rem $Header: rdbms/admin/spcpkg.sql /st_rdbms_11.2.0/2 2012/03/06 15:07:48 shsong Exp $
SQL> Rem
SQL> Rem spcpkg.sql
SQL> Rem
SQL> Rem Copyright (c) 1999, 2012, Oracle and/or its affiliates.
SQL> Rem All rights reserved.
SQL> Rem
SQL> Rem    NAME
SQL> Rem         spcpkg.sql
SQL> Rem
SQL> Rem    DESCRIPTION
SQL> Rem         SQL*PLUS command file to create statistics package
SQL> Rem
SQL> Rem    NOTES
SQL> Rem         Must be run as the STATSPACK owner, PERFSTAT
SQL> Rem
SQL> Rem    MODIFIED   (MM/DD/YY)
SQL> Rem    arogers     01/23/08 - 6523482 - change VM_IN/OUT_BYTES id numbers
SQL> Rem    cdgreen     03/14/07 - 11 F2
SQL> Rem    shsong      06/14/07 - Fix BUFFER_GETS
SQL> Rem    cdgreen     04/05/07 - 5691086
SQL> Rem    cdgreen     03/02/07 - use _FG for v$system_event
SQL> Rem    cdgreen     03/02/07 - 5913378
SQL> Rem    cdgreen     05/16/06 - 11 F1
SQL> Rem    cdgreen     05/10/06 - 5215982
SQL> Rem    cdgreen     05/24/05 - 4246955
SQL> Rem    cdgreen     04/18/05 - 4228432
SQL> Rem    cdgreen     02/28/05 - 10gR2 misc
SQL> Rem    vbarrier    02/18/05 - 4081984
SQL> Rem    cdgreen     01/25/05 - 4143812
SQL> Rem    cdgreen     10/29/04 - 10gR2_sqlstats
SQL> Rem    cdgreen     10/25/04 - 3970898
SQL> Rem    cdgreen     07/16/04 - 10g R2
SQL> Rem    vbarrier    03/18/04 - 3517841
SQL> Rem    vbarrier    02/12/04 - 3412853
SQL> Rem    cdialeri    12/04/03 - 3290482
SQL> Rem    cdialeri    11/05/03 - 3202706
SQL> Rem    cdialeri    10/14/03 - 10g - streams - rvenkate
SQL> Rem    cdialeri    08/05/03 - 10g F3
SQL> Rem    cdialeri    07/31/03 - 2804307
SQL> Rem    vbarrier    02/25/03 - 10g RAC
SQL> Rem    cdialeri    01/28/03 - 10g F2: baseline, purge
SQL> Rem    cdialeri    11/15/02 - 10g F1
SQL> Rem    cdialeri    10/29/02 - 2648471
SQL> Rem    cdialeri    09/11/02 - 1995145
SQL> Rem    vbarrier    04/18/02 - 2271895
SQL> Rem    vbarrier    03/20/02 - 2184504
SQL> Rem    spommere    03/19/02 - 2274095
SQL> Rem    vbarrier    03/05/02 - Segment Statistics
SQL> Rem    spommere    02/14/02 - cleanup RAC stats that are no longer needed
SQL> Rem    spommere    02/08/02 - 2212357
SQL> Rem    cdialeri    02/07/02 - 2218573
SQL> Rem    cdialeri    01/30/02 - 2184717
SQL> Rem    cdialeri    01/09/02 - 9.2 - features 2
SQL> Rem    cdialeri    11/30/01 - 9.2 - features 1
SQL> Rem    hbergh      08/23/01 - 1940915: use substrb on sql_text
SQL> Rem    cdialeri    04/26/01 - 9.0
SQL> Rem    cdialeri    09/12/00 - sp_1404195
SQL> Rem    cdialeri    04/07/00 - 1261813
SQL> Rem    cdialeri    03/28/00 - sp_purge
SQL> Rem    cdialeri    02/16/00 - 1191805
SQL> Rem    cdialeri    11/01/99 - Enhance, 1059172
SQL> Rem    cgervasi    06/16/98 - Remove references to wrqs
SQL> Rem    cmlim       07/30/97 - Modified system events
SQL> Rem    gwood.uk    02/30/94 - Modified
SQL> Rem    densor.uk   03/31/93 - Modified
SQL> Rem    cellis.uk   11/15/89 - Created
SQL> Rem
SQL>
SQL> set echo off;
Creating Package STATSPACK...

Package created.

Elapsed: 00:00:00.35
No errors.
Creating Package Body STATSPACK...

Package body created.

Elapsed: 00:00:01.59
No errors.

NOTE:
SPCPKG complete. Please check spcpkg.lis for any errors.

SQL> EXEC STATSPACK.SNAP();

PL/SQL procedure successfully completed.

Elapsed: 00:00:02.13
SQL> --Sudah terinstall
SQL> @?/rdbms/admin/spreport
SQL> Rem
SQL> Rem $Header: spreport.sql 22-apr-2001.15:44:01 cdialeri Exp $
SQL> Rem
SQL> Rem spreport.sql
SQL> Rem
SQL> Rem  Copyright (c) Oracle Corporation 1999, 2000. All Rights Reserved.
SQL> Rem
SQL> Rem    NAME
SQL> Rem         spreport.sql
SQL> Rem
SQL> Rem    DESCRIPTION
SQL> Rem         This script defaults the dbid and instance number to that of the
SQL> Rem         current instance connected-to, then calls sprepins.sql to produce
SQL> Rem         the standard Statspack report.
SQL> Rem
SQL> Rem    NOTES
SQL> Rem         Usually run as the STATSPACK owner, PERFSTAT
SQL> Rem
SQL> Rem    MODIFIED   (MM/DD/YY)
SQL> Rem    cdialeri    03/20/01 - 1747076
SQL> Rem    cdialeri    03/12/01 - Created
SQL>
SQL> --
SQL> -- Get the current database/instance information - this will be used
SQL> -- later in the report along with bid, eid to lookup snapshots
SQL>
SQL> column inst_num  heading "Inst Num"  new_value inst_num  format 99999;
SQL> column inst_name heading "Instance"  new_value inst_name format a12;
SQL> column db_name      heading "DB Name"   new_value db_name   format a12;
SQL> column dbid         heading "DB Id"          new_value dbid      format 9999999999 just c;
SQL>
SQL> prompt

SQL> prompt Current Instance
Current Instance
SQL> prompt ~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~
SQL>
SQL> select d.dbid            dbid
  2       , d.name            db_name
  3       , i.instance_number inst_num
  4       , i.instance_name   inst_name
  5    from v$database d,
  6         v$instance i;

   DB Id    DB Name      Inst Num Instance
----------- ------------ -------- ------------
 1793076180 AYAM                1 ayam

1 row selected.

Elapsed: 00:00:00.02
SQL>
SQL> @@sprepins
SQL> Rem
SQL> Rem $Header: rdbms/admin/sprepins.sql /st_rdbms_11.2.0/2 2012/03/06 15:07:48 shsong Exp $
SQL> Rem
SQL> Rem sprepins.sql
SQL> Rem
SQL> Rem Copyright (c) 2001, 2012, Oracle and/or its affiliates.
SQL> Rem All rights reserved.
SQL> Rem
SQL> Rem    NAME
SQL> Rem         sprepins.sql - StatsPack Report Instance
SQL> Rem
SQL> Rem    DESCRIPTION
SQL> Rem         SQL*Plus command file to report on differences between
SQL> Rem         values recorded in two snapshots.
SQL> Rem
SQL> Rem         This script requests the user for the dbid and instance number
SQL> Rem         of the instance to report on, before producing the standard
SQL> Rem         Statspack report.
SQL> Rem
SQL> Rem    NOTES
SQL> Rem         Usually run as the STATSPACK owner, PERFSTAT
SQL> Rem
SQL> Rem    MODIFIED   (MM/DD/YY)
SQL> Rem    yberezin    07/27/09 - bug 8639400
SQL> Rem    pmurthy     12/10/08 - Fix for Bug - 7149145
SQL> Rem    bnayak      09/23/08 - To fix Bug 7385751
SQL> Rem    cdgreen     12/03/07 - Streams - AWR sync
SQL> Rem    cdgreen     08/20/07 - 6317857
SQL> Rem    cdgreen     08/10/07 - 6335987
SQL> Rem    cdgreen     03/14/07 - 11 F2
SQL> Rem    cdgreen     03/02/07 - use _FG for v$system_event
SQL> Rem    cdgreen     05/11/06 - 11 F1
SQL> Rem    cdgreen     01/30/06 - 4631691
SQL> Rem    cdgreen     05/05/06 - 5145816
SQL> Rem    cdgreen     05/10/06 - 5215982
SQL> Rem    cdgreen     05/23/05 - 4246955
SQL> Rem    cdgreen     02/28/05 - 10gR2 misc
SQL> Rem    vbarrier    02/18/05 - 4081984/4071648
SQL> Rem    cdgreen     10/29/04 - 10gR2_sqlstats
SQL> Rem    cdgreen     10/25/04 - 3970898
SQL> Rem    vbarrier    09/03/04 - Wait Event Histogram
SQL> Rem    cdgreen     07/15/04 - sp_10_r2
SQL> Rem    cdialeri    03/30/04 - 3356242
SQL> Rem    vbarrier    03/18/04 - 3517841
SQL> Rem    vbarrier    02/12/04 - 3412853/3378066
SQL> Rem    vbarrier    01/30/04 - 3411063/3411129
SQL> Rem    cdialeri    12/03/03 - 3290482
SQL> Rem    cdialeri    10/14/03 - 10g - streams - rvenkate
SQL> Rem    cdialeri    08/06/03 - 10g F3
SQL> Rem    vbarrier    02/25/03 - 10g RAC
SQL> Rem    cdialeri    11/15/02 - 10g R1
SQL> Rem    cdialeri    10/29/02 - 2648471
SQL> Rem    cdialeri    09/26/02 - 10.0
SQL> Rem    vbarrier    07/14/02 - Segment Statistics: outerjoin + order by
SQL> Rem    vbarrier    07/10/02 - Input checking + capt/tot SQL + snapdays
SQL> Rem    vbarrier    03/20/02 - Module in SQL reporting + 2188360
SQL> Rem    vbarrier    03/05/02 - Segment Statistics
SQL> Rem    spommere    02/14/02 - cleanup RAC stats that are no longer needed
SQL> Rem    spommere    02/08/02 - 2212357
SQL> Rem    cdialeri    02/07/02 - 2218573
SQL> Rem    cdialeri    01/30/02 - 2184717
SQL> Rem    cdialeri    01/09/02 - 9.2 - features 2
SQL> Rem    ykunitom    12/21/01 - 1396578: fixed '% Non-Parse CPU'
SQL> Rem    cdialeri    12/19/01 - 9.2 - features 1
SQL> Rem    cdialeri    09/20/01 - 1767338,1910458,1774694
SQL> Rem    cdialeri    04/26/01 - Renamed from spreport.sql
SQL> Rem    cdialeri    03/02/01 - 9.0
SQL> Rem    cdialeri    09/12/00 - sp_1404195
SQL> Rem    cdialeri    07/10/00 - 1349995
SQL> Rem    cdialeri    06/21/00 - 1336259
SQL> Rem    cdialeri    04/06/00 - 1261813
SQL> Rem    cdialeri    03/28/00 - sp_purge
SQL> Rem    cdialeri    02/16/00 - 1191805
SQL> Rem    cdialeri    11/01/99 - Enhance, 1059172
SQL> Rem    cgervasi    06/16/98 - Remove references to wrqs
SQL> Rem    cmlim       07/30/97 - Modified system events
SQL> Rem    gwood.uk    02/30/94 - Modified
SQL> Rem    densor.uk   03/31/93 - Modified
SQL> Rem    cellis.uk   11/15/89 - Created
SQL> Rem
SQL>
SQL>
SQL> --
SQL> -- Get the report settings
SQL> @@sprepcon.sql
SQL> Rem
SQL> Rem $Header: sprepcon.sql 02-mar-2005.11:50:27 cdgreen Exp $
SQL> Rem
SQL> Rem sprepcon.sql
SQL> Rem
SQL> Rem Copyright (c) 2001, 2005, Oracle. All rights reserved.
SQL> Rem
SQL> Rem    NAME
SQL> Rem         sprepcon.sql - StatsPack REPort CONfiguration
SQL> Rem
SQL> Rem    DESCRIPTION
SQL> Rem         SQL*Plus command file which allows configuration of certain
SQL> Rem         aspects of the instance report
SQL> Rem
SQL> Rem    NOTES
SQL> Rem         To change the default settings, this file should be copied by
SQL> Rem         the user, then modified with the desired settings
SQL> Rem
SQL> Rem    MODIFIED   (MM/DD/YY)
SQL> Rem    cdgreen     03/02/05 - 10gR2 misc
SQL> Rem    cdgreen     01/19/05 - Undostat threshold
SQL> Rem    cdgreen     07/30/04 - sp_10_r2
SQL> Rem    vbarrier    02/12/04 - 3412853
SQL> Rem    cdialeri    10/14/03 - 10g - streams - rvenkate
SQL> Rem    cdialeri    10/07/03 - cdialeri_sp_10_f3
SQL> Rem    cdialeri    08/06/03 - Created
SQL> Rem
SQL>
SQL> Rem        -------------        Beginning of                -----------
> Rem     ------------- Customer Configurable Report Settings -----------
>
SQL> --
SQL> -- Snapshot related report settings
SQL>
SQL> -- The default number of days of snapshots to list when displaying the
SQL> -- list of snapshots to choose the begin and end snapshot Ids from.
SQL> --
SQL> --   List all snapshots
SQL> define num_days = '';
SQL> --
SQL> --   List last 31 days
SQL> -- define num_days = 31;
SQL> --
SQL> --   List no (i.e. 0) snapshots
SQL> -- define num_days = 0;
SQL>
SQL>
SQL> -- -------------------------------------------------------------------------
SQL>
SQL> --
SQL> -- SQL related report settings
SQL>
SQL> -- Number of Rows of SQL to display in each SQL section of the report
SQL> define top_n_sql = 65;
SQL>
SQL> -- Number of rows of SQL Text to print in the SQL sections of the report
SQL> -- for each hash_value
SQL> define num_rows_per_hash = 4;
SQL>
SQL> -- Filter which restricts the rows of SQL shown in the SQL sections of the
SQL> -- report to be the top N pct
SQL> define top_pct_sql = 1.0;
SQL>
SQL>
SQL> -- -------------------------------------------------------------------------
SQL>
SQL> --
SQL> -- Segment related report settings
SQL>
SQL> -- The number of top segments to display in each of the High-Load Segment
SQL> -- sections of the report
SQL> define top_n_segstat = 5;
SQL>
SQL>
SQL> -- -------------------------------------------------------------------------
SQL>
SQL> --
SQL> --  Rollback Segment and Auto-Undo segment stats
SQL>
SQL> --
SQL> -- Whether or not to display rollback segment stats.  Value of N is only
SQL> -- honoured only if Auto-Undo is enabled.  Valid values are N or Y
SQL>
SQL> -- Display Rollstat stats
SQL> --define display_rollstat = 'Y';
SQL> -- Do not display Rollstat stats
SQL> define display_rollstat = 'N';
SQL>
SQL> -- Whether or not to Auto-undo segment stats.  Valid values are N or Y
SQL> -- Display unodstat stats
SQL> define display_undostat = 'Y';
SQL> -- Do not display unodstat stats
SQL> --define display_undostat = 'N';
SQL> -- Number of undostat entries to show
SQL> define top_n_undostat = 35;
SQL>
SQL>
SQL> -- -------------------------------------------------------------------------
SQL>
SQL> --
SQL> -- File IO statistics related report settings
SQL>
SQL> --
SQL> -- BEWARE - only comment this section out if you KNOW you do not have
SQL> -- IO problems!
SQL>
SQL> -- Display file-level statistics in the report
SQL> define display_file_io = 'Y';
SQL> -- Do not display file-level statistics in the report
SQL> --define display_file_io = 'N';
SQL>
SQL>
SQL> -- -------------------------------------------------------------------------
SQL>
SQL> --
SQL> --  File and Event Histogram Stats
SQL>
SQL> --
SQL> -- File Histogram statistics related report settings
SQL>
SQL>
SQL> -- Do not print File Histogram stats in the report
SQL> --define file_histogram = N;
SQL> -- Display File Histogram stats in the report
SQL> define file_histogram = 'Y';
SQL>
SQL>
SQL> --
SQL> -- Event Histogram statistics related report settings
SQL> -- (whether or not to display histogram statistics in the report)
SQL>
SQL> --  Do not print Event Histogram stats
SQL> --define event_histogram = N;
SQL> --  Print Event histogram stats
SQL> define event_histogram = 'Y';
SQL>
SQL>
SQL> -- -------------------------------------------------------------------------
SQL>
SQL> --
SQL> -- Streams related report settings
SQL> --
SQL> define streams_top_n = 25
SQL>
SQL>
SQL> -- -------------------------------------------------------------------------
SQL>
SQL> --
SQL> -- RAC Global Cache Transfer Statistics related report setting
SQL> -- (should the cache transfer statistics be detailed per instance)
SQL>
SQL> -- Print aggregated cache transfer statistics
SQL> --define cache_xfer_per_instance = 'N';
SQL> --  Print per instance cache transfer statistics
SQL> define cache_xfer_per_instance = 'Y';
SQL>
SQL>
SQL> -- -------------------------------------------------------------------------
SQL>
SQL> --
SQL> -- SGA Stat report settings
SQL> define sgastat_top_n = 35
SQL>
SQL>
SQL> -- -------------------------------------------------------------------------
SQL>
SQL> --
SQL> -- Wait Events - average wait time granularity for System Event section
SQL> -- of Instance report
SQL> -- NOTE:  when increasing the width of avwt_fmt, you might also want to
SQL> -- increase report linesize width.
SQL> -- Changing the defaults for the two values below is only recommended for
SQL> -- benchmark situations which require finer granularity timings.
SQL> define avwt_fmt     = 99990
SQL> define linesize_fmt = 80
SQL> --define avwt_fmt     = 99990.99
SQL> --define linesize_fmt = 83
SQL>
SQL>
SQL>
SQL> -- -------------------------------------------------------------------------
SQL>
SQL> Rem        -------------             End  of                -----------
> Rem     ------------- Customer Configurable Report Settings -----------
> -- -------------------------------------------------------------------------
SQL>
SQL>
SQL> --
SQL> --
SQL>
SQL> clear break compute;
SQL> repfooter off;
SQL> ttitle off;
SQL> btitle off;
SQL> set timing off veri off space 1 flush on pause off termout on numwidth 10;
SQL> set echo off feedback off pagesize 60 newpage 1 recsep off;


Instances in this Statspack schema
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   DB Id    Inst Num DB Name      Instance     Host
----------- -------- ------------ ------------ ------------
 1793076180        1 AYAM         ayam         pitik

Using 1793076180 for database Id
Using          1 for instance number


Specify the number of days of snapshots to choose from
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Entering the number of days (n) will result in the most recent
(n) days of snapshots being listed.  Pressing <return> without
specifying a number lists all completed snapshots.



Listing all Completed Snapshots

                                                       Snap
Instance     DB Name        Snap Id   Snap Started    Level Comment
------------ ------------ --------- ----------------- ----- --------------------
ayam         AYAM                 1 11 Jan 2016 13:33     5



Specify the Begin and End Snapshot Ids
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Enter value for begin_snap: