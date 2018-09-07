SQL> SELECT TABLE_NAME FROM USER_TABLES;

TABLE_NAME
------------------------------
GSXR_3
GSXR_2
GSXR

SQL> DROP TABLE AZIZPW.GSXR;

Table dropped.

SQL> SELECT OWNER, ORIGINAL_NAME, TYPE, DROPTIME FROM DBA_RECYCLEBIN;

OWNER			       ORIGINAL_NAME			TYPE			  DROPTIME
------------------------------ -------------------------------- ------------------------- -------------------
AZIZPW			       GSXR				TABLE			  2014-11-11:14:50:53

SQL> SELECT TABLE_NAME FROM USER_TABLES;

TABLE_NAME
------------------------------
GSXR_3
GSXR_2

SQL> DELETE FROM AZIZPW.GSXR_2 WHERE CYLVOLUME=600;

1 row deleted.

SQL> DELETE FROM AZIZPW.GSXR_2 WHERE CYLVOLUME=750;

1 row deleted.

SQL> DELETE FROM AZIZPW.GSXR_3 WHERE CYLVOLUME=600;

1 row deleted.

SQL> COMMIT;

Commit complete.

SQL> SELECT (SELECT COUNT(1)GSXR_2 FROM AZIZPW.GSXR_2)GSXR_2, (SELECT COUNT(1)GSXR_3 FROM AZIZPW.GSXR_3)GSXR_3 FROM DUAL;

    GSXR_2     GSXR_3
---------- ----------
	 2	    3

SQL> CREATE TABLE AZIZPW.GSXR AS SELECT * FROM AZIZPW.GSXR_2;

Table created.

SQL> SELECT COUNT(1)JMLROW FROM AZIZPW.GSXR;

    JMLROW
----------
	 2

SQL> SELECT TABLE_NAME FROM USER_TABLES;

TABLE_NAME
------------------------------
GSXR
GSXR_3
GSXR_2

SQL> DROP TABLE GSXR;

Table dropped.

SQL> SELECT OWNER, ORIGINAL_NAME, TYPE, DROPTIME FROM DBA_RECYCLEBIN;

OWNER			       ORIGINAL_NAME			TYPE			  DROPTIME
------------------------------ -------------------------------- ------------------------- -------------------
AZIZPW			       GSXR				TABLE			  2014-11-11:14:50:53
AZIZPW			       GSXR				TABLE			  2014-11-11:14:58:54

SQL> CREATE TABLE AZIZPW.GSXR AS SELECT * FROM AZIZPW.GSXR_3;

Table created.

SQL> SELECT COUNT(1)JMLROW FROM AZIZPW.GSXR;

    JMLROW
----------
	 3

SQL> SELECT TABLE_NAME FROM USER_TABLES;

TABLE_NAME
------------------------------
GSXR
GSXR_3
GSXR_2

SQL> DROP TABLE GSXR;

Table dropped.

SQL> SELECT OWNER, ORIGINAL_NAME, TYPE, DROPTIME FROM DBA_RECYCLEBIN ORDER BY 4 DESC;

OWNER			       ORIGINAL_NAME			TYPE			  DROPTIME
------------------------------ -------------------------------- ------------------------- -------------------
AZIZPW			       GSXR				TABLE			  2014-11-11:15:03:09
AZIZPW			       GSXR				TABLE			  2014-11-11:14:58:54
AZIZPW			       GSXR				TABLE			  2014-11-11:14:50:53

SQL> FLASHBACK TABLE AZIZPW.GSXR TO BEFORE DROP;

Flashback complete.

SQL> SELECT TABLE_NAME FROM USER_TABLES;

TABLE_NAME
------------------------------
GSXR
GSXR_3
GSXR_2

SQL> SELECT COUNT(1)JMLROW FROM AZIZPW.GSXR;

    JMLROW
----------
	 3

SQL> FLASHBACK TABLE AZIZPW.GSXR TO BEFORE DROP;
FLASHBACK TABLE AZIZPW.GSXR TO BEFORE DROP
*
ERROR at line 1:
ORA-38312: original name is used by an existing object


SQL> FLASHBACK TABLE AZIZPW.GSXR TO BEFORE DROP RENAME TO GSXRFLASHBACK_2;

Flashback complete.

SQL> SELECT COUNT(1)JMLROW FROM AZIZPW.GSXRFLASHBACK_2;

    JMLROW
----------
	 2

SQL> SELECT TYPE, OBJECT_NAME, OWNER||'.'||ORIGINAL_NAME NAMA, DROPTIME FROM DBA_RECYCLEBIN ORDER BY 4 DESC;

TYPE			  OBJECT_NAME			 NAMA								 DROPTIME
------------------------- ------------------------------ --------------------------------------------------------------- -------------------
TABLE			  BIN$B5GJ30rNHPrgU4ctEKy6xg==$0 AZIZPW.GSXR							 2014-11-11:14:50:53

SQL> SELECT COUNT(1)JMLROW FROM "BIN$B5GJ30rNHPrgU4ctEKy6xg==$0";

    JMLROW
----------
	 4

SQL> --ITU YANG ASLI PERTAMA KALI DROP TABLE;
SQL> FLASHBACK TABLE AZIZPW.GSXR TO BEFORE DROP RENAME TO GSXRFLASHBACK_ASLI;

Flashback complete.

SQL> DROP TABLE GSXR;

Table dropped.

SQL> ALTER TABLE AZIZPW.GSXRFLASHBACK_2 RENAME TO GSXR;

Table altered.

SQL> DROP TABLE AZIZPW.GSXR;

Table dropped.

SQL> CREATE TABLE AZIZPW.GSXR AS SELECT * FROM AZIZPW.GSXR_2;

Table created.

SQL> SELECT TABLE_NAME FROM USER_TABLES;

TABLE_NAME
------------------------------
GSXR
GSXR_3
GSXR_2
GSXRFLASHBACK_ASLI

SQL> SELECT TYPE, OBJECT_NAME, OWNER||'.'||ORIGINAL_NAME NAMA, DROPTIME FROM DBA_RECYCLEBIN ORDER BY 4 DESC;

TYPE			  OBJECT_NAME			 NAMA								 DROPTIME
------------------------- ------------------------------ --------------------------------------------------------------- -------------------
TABLE			  BIN$B5GJ30rRHPrgU4ctEKy6xg==$0 AZIZPW.GSXR							 2014-11-11:15:19:30
TABLE			  BIN$B5GJ30rQHPrgU4ctEKy6xg==$0 AZIZPW.GSXR							 2014-11-11:15:17:52

SQL> PURGE TABLE GSXR;

Table purged.

SQL> SELECT TYPE, OBJECT_NAME, OWNER||'.'||ORIGINAL_NAME NAMA, DROPTIME FROM DBA_RECYCLEBIN ORDER BY 4 DESC;

TYPE			  OBJECT_NAME			 NAMA								 DROPTIME
------------------------- ------------------------------ --------------------------------------------------------------- -------------------
TABLE			  BIN$B5GJ30rRHPrgU4ctEKy6xg==$0 AZIZPW.GSXR							 2014-11-11:15:19:30

SQL> --Ternyata purge-nya table di recyclebin yang paling awal
SQL> SELECT TABLE_NAME FROM USER_TABLES;

TABLE_NAME
------------------------------
GSXR
GSXR_3
GSXR_2
GSXRFLASHBACK_ASLI

SQL> PURGE RECYCLEBIN/*Kosongin recyclebin*/;

Recyclebin purged.

SQL> SELECT TYPE, OBJECT_NAME, OWNER||'.'||ORIGINAL_NAME NAMA, DROPTIME FROM DBA_RECYCLEBIN ORDER BY 4 DESC;

no rows selected

SQL> DROP TABLE AZIZPW.GSXR PURGE/*Drop tanpa ampun(tanpa masuk ke recyclebin)*/;

Table dropped.

SQL>