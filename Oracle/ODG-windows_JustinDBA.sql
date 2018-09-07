/*TUTORIAL ORACLE DATA GUARD DI MICROSOFT WINDOWS OS
DIAMBIL DARI VIDEO JUSTIN DBA*/
set ORACLE_SID=primer
echo %ORACLE_SID%

SQLPLUS / AS SYSDBA
SHOW USER;
SELECT NAME, FORCE_LOGGING, LOG_MODE, OPEN_MODE, DATABASE_ROLE FROM V$DATABASE;
ALTER DATABASE FORCE LOGGING;
--apabila LOG_MODE=NOARCHIVELOG, set menjadi ARCHIVELOG dengan perintah:
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;
--
SELECT NAME FROM V$DATAFILE;
SELECT NAME FROM V$TEMPFILE;
SELECT TABLESPACE_NAME FROM DBA_TABLESPACES;
SELECT NAME FROM V$CONTROLFILE;
SELECT MEMBER FROM V$LOGFILE;
QUIT
--Masuk dan hihat isi direktori oradata/primer
--Buat folder untuk menampung archive log di direktori itu, misal buat folder ARCHIVE_LOG
SQLPLUS / AS SYSDBA
ARCHIVE LOG LIST;
--Pastikan Archive destination ada pada folder yang dibuat (ARCHIVE_LOG)
HOST
DIR ARCHIVE_LOG
--Harusnya terdapat archive_log
EXIT
QUIT
--Masuk dan lihat isi direktori app/product/11*/db*/database, lihat: DIR *primer.ora
--Gandakan passwordfile: copy PWDprimer.ora PWDprimer2.ora
--pastikan lagi bahwa passwordfile ada 2: dir PWDprimer*
SQLPLUS / AS SYSDBA
SHOW PARAMETER SPFILE;
--alter system set DB_NAME=ORCL scope=spfile;
--alter system set DB_UNIQUE_NAME=ORCL scope=spfile;
--alter system set LOG_ARCHIVE_CONFIG='DG_CONFIG=(ORCL,PAPUA)' scope=spfile;
--alter system set CONTROL_FILES='C:\ora\abc\oradata\ORCL\CONTROL01.CTL', 'C:\ora\abc\flash_recovery_area\ORCL\CONTROL02.CTL';
--ALTER SYSTEM SET LOG_ARCHIVE_DEST_1='LOCATION=C:\ora\abc\oradata\ORCL\ARCHIVED_LOGS\ VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=ORCL' SCOPE=SPFILE;
--ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=PAPUA ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=PAPUA' SCOPE=SPFILE;
--ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_1=ENABLE SCOPE=SPFILE;
--ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=ENABLE SCOPE SPFILE;
--ALTER SYSTEM SET REMOTE_LOGIN_PASSWORDFILE=EXCLUSIVE SCOPE=SPFILE;
--ALTER SYSTEM SET FAL_SERVER=PAPUA SCOPE=SPFILE;
--ALTER SYSTEM SET DB_FILE_NAME_CONVERT='PAPUA','ORCL' SCOPE=SPFILE;
--ALTER SYSTEM SET LOG_FILE_NAME_CONVERT='PAPUA','ORCL' SCOPE=SPFILE;

alter system set db_name=primer scope=spfile;
alter system set db_unique_name=primer scope=spfile;
alter system set log_archive_config='dg_config=(primer,bali)' scope=spfile;
alter system set control_files='C:\ora\oradata\primer\CONTROL01.CTL','C:\ora\flash_recovery_area\primer\CONTROL02.CTL' scope=spfile;
alter system set log_archive_dest_1='location=C:\ora\oradata\primer\ARCHIVED_LOGS\ valid_for=(all_logfiles,all_roles) db_unique_name=primer' scope=spfile;
alter system set log_archive_dest_2='service=192.168.115.146:1521/bali async valid_for=(online_logfiles,primary_role) db_unique_name=bali' scope=spfile;
alter system set log_archive_dest_state_1=enable scope=spfile;
alter system set log_archive_dest_state_2=enable scope=spfile;
alter system set remote_login_passwordfile=exclusive scope=spfile;
alter system set log_archive_format='%t_%s_%r.arc' scope=spfile;
alter system set fal_server='192.168.115.146:1521/bali' scope=spfile;
alter system set db_file_name_convert='bali','primer' scope=spfile;
alter system set log_file_name_convert='bali','primer' scope=spfile;
alter system set standby_file_management=auto scope=spfile;

STARTUP FORCE;
SELECT NAME, FORCE_LOGGING, LOG_MODE, OPEN_MODE, DATABASE_ROLE FROM V$DATABASE;
ALTER SYSTEM ARCHIVE LOG CURRENT;
SELECT * FROM V$BACKUP;
ALTER DATABASE BEGIN BACKUP;
SELECT * FROM V$BACKUP;
QUIT;
--Buat folder backup, mislnya C:\BACKUP
--Masuk dan hihat isi direktori oradata/primer
--Copy semua databasefile ke C:\BACKUP: COPY *.DBF C:\BACKUP
SQLPLUS / AS SYSDBA
SELECT * FROM V$BACKUP;
ALTER DATABASE END BACKUP;
SELECT * FROM V$BACKUP;
ALTER SYSTEM ARCHIVE LOG CURRENT;
ALTER DATABASE CREATE STANDBY CONTROLFILE AS 'C:\CONTROL.STY';
QUIT
--Masuk ke direktori oradata, buat folder primer2 dan di dalamnya ada folder ARCHIVE_LOG
--Masuk ke direktori primer2
--Copy semua dari C:\BACKUP ke primer2
MOVE CONTROL.STY CONTROL01.CTL
COPY CONTROL01.CTL CONTROL02.CTL
COPY CONTROL02.CTL CONTROL03.CTL
--Masuk dan lihat isi direktori product/11.*/db_*/database/
EDIT initdb02.ora, isi: db_name=db01, save dan exit /*bikin file baru*/
ORADIM -NEW -SID db02
NET START OracleServicedb02
set ORACLE_SID=db02
SQLPLUS / AS SYSDBA
CREATE SPFILE FROM PFILE;
QUIT;
DIR *db02*
SQLPLUS / AS SYSDBA
STARTUP NOMOUNT;
HOST
echo %ORACLE_SID%
EXIT
--ALTER SYSTEM SET DB_UNIQUE_NAME=ORCL2 SCOPE=SPFILE;
--ALTER SYSTEM SET LOG_ARCHIVE_CONFIG='DG_CONFIG=(ORCL,ORCL2)' SCOPE=SPFILE;
--ALTER SYSTEM SET LOG_ARCHIVE_DEST_1='location=C:\ora\abc\oradata\ORCL2\ARCHIVED_LOGS\ VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=ORCL2' SCOPE=SPFILE;
--ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='service=ORCL ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=ORCL' SCOPE=SPFILE;
--ALTER SYSTEM SET DB_FILE_NAME_CONVERT='ORCL','ORCL2' SCOPE=SPFILE;
--ALTER SYSTEM SET LOG_FILE_NAME_CONVERT='ORCL','ORCL2' SCOPE=SPFILE;
--ALTER SYSTEM SET CONTROL_FILES='C:\ora\abc\oradata\ORCL2\CONTROL01.CTL','C:\ora\abc\oradata\ORCL2\CONTROL02.CTL','C:\ora\abc\oradata\ORCL2\CONTROL03.CTL' SCOPE=SPFILE;
--ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_1=ENABLE SCOPE=SPFILE;
--ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=ENABLE SCOPE=SPFILE;
--ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=AUTO SCOPE=SPFILE;
--ALTER SYSTEM SET FAL_SERVER=ORCL SCOPE=SPFILE;

ALTER SYSTEM SET DB_NAME=primer scope=spfile;
ALTER SYSTEM SET DB_UNIQUE_NAME=bali scope=spfile;
ALTER SYSTEM SET LOG_ARCHIVE_CONFIG='DG_CONFIG=(primer,bali)' scope=spfile;
ALTER SYSTEM SET CONTROL_FILES='C:\ora\oradata\bali\CONTROL01.CTL','C:\ora\oradata\bali\CONTROL02.CTL','C:\ora\oradata\bali\CONTROL03.CTL' scope=spfile;
ALTER SYSTEM SET DB_FILE_NAME_CONVERT='primer','bali' scope=spfile;
ALTER SYSTEM SET LOG_FILE_NAME_CONVERT='primer','bali' scope=spfile;
ALTER SYSTEM SET LOG_ARCHIVE_FORMAT='%t_%s_%r.arc' scope=spfile;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1='LOCATION=C:\ora\oradata\bali\ARCHIVED_LOGS\ VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=bali' scope=spfile;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=192.168.115.145:1521/primer ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=primer' scope=spfile;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_1=ENABLE scope=spfile;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=ENABLE scope=spfile;
ALTER SYSTEM SET REMOTE_LOGIN_PASSWORDFILE=EXCLUSIVE scope=spfile;
ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=AUTO scope=spfile;
ALTER SYSTEM SET FAL_SERVER=primer scope=spfile;

STARTUP NOMOUNT FORCE;
QUIT
SQLPLUS / AS SYSDBA
CREATE PFILE FROM SPFILE;
QUIT
EDIT initdb02.ora
--Tambahkan:
*.control_files='C:\ora\oradata\db02\CONTROL01.CTL','C:\ora\oradata\db02\CONTROL02.CTL','C:\ora\oradata\db02\CONTROL03.CTL'
SQLPLUS / AS SYSDBA
SHUTDOWN ABORT;
CREATE SPFILE FROM PFILE;
STARTUP MOUNT;
QUIT;
--Masuk ke direktori oradata\db01\ dan lihat isi direktori ARCHIVE_LOG
set ORACLE_SID=db02
SQLPLUS / AS SYSDBA
SET LOGSOURCE 'C:\ora\oradata\primer\ARCHIVED_LOGS';
RECOVER STANDBY DATABASE UNTIL CANCEL USING BACKUP CONTROLFILE;
--ENTER AJA
--CANCEL
QUIT;
SQLPLUS / AS SYSDBA
RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION/*Media recovery complete*/;
QUIT;
--Masuk ke direktori c:\app\prastyo\diag\rdbms\db02\db02\trace 
TYPE ALERT_db02.LOG
--Baris terakhir: media recovery waiting for thread .......
--Matikan Oracle, bikin TNS baru di file C:\ora\product\11.2.0\dbhome_1\NETWORK\ADMIN\tnsnames.ora tapi backup dulu sebelumnya
LSNRCTL START
--TNSListener untuk db02
TNSPING db02
--OK
TNSPING db01
--OK
set ORACLE_SID=ORCL
SQLPLUS / AS SYSDBA
SELECT NAME, FORCE_LOGGING, LOG_MODE, OPEN_MODE, DATABASE_ROLE FROM V$DATABASE;
SHUTDOWN IMMEDIATE;
STARTUP;
QUIT;
--Masuk ke direktori C:\ora\diag\rdbms\db01\db01\trace
TYPE ALERT_db01.LOG
--2 baris terakhir: Setting Resource Manager plan ...
--Lihat isi direktori ARCHIVE_LOG di db02
set ORACLE_SID=db01
SQLPLUS / AS SYSDBA
ARCHIVE LOG LIST;
ALTER SYSTEM ARCHIVE LOG CURRENT;
ARCHIVE LOG LIST;
SELECT NAME, FORCE_LOGGING, LOG_MODE, OPEN_MODE, DATABASE_ROLE FROM V$DATABASE;
QUIT;
--Lihat isi direktori ARCHIVE_LOG di db02, seharusnya bertambah
SQLPLUS / AS SYSDBA
SELECT NAME, FORCE_LOGGING, LOG_MODE, OPEN_MODE, DATABASE_ROLE FROM V$DATABASE;
ALTER SYSTEM ARCHIVE LOG CURRENT;
ARCHIVE LOG LIST;
--Jika di primary terdapat 8 archive log, maka di standby terdapat 9 archive log
--Masuk ke direktori c:\app\prastyo\diag\rdbms\primer2\primer2\trace
TYPE ALERT_primer2.LOG
--Lihat di sana ada transfer log (Media recovery log ...)
--Cek juga yang di primary TYPE ALERT_primer.LOG
--Thread 1 advance to log sequence ...
set ORACLE_SID=primer
SQLPLUS / AS SYSDBA
CREATE TABLE NEW_TABLE (DATA VARCHAR2(20));
DESC NEW_TABLE;
SELECT * FROM NEW_TABLE;
INSERT INTO NEW_TABLE VALUES('DATA');
INSERT INTO NEW_TABLE VALUES('FROM');
INSERT INTO NEW_TABLE VALUES('PRIMARY');
COMMIT;
SELECT * FROM NEW_TABLE;
SELECT NAME, FORCE_LOGGING, LOG_MODE, OPEN_MODE, DATABASE_ROLE FROM V$DATABASE;
ALTER SYSTEM ARCHIVE LOG CURRENT;
ARCHIVE LOG LIST;
set ORACLE_SID=primer2
SQLPLUS / AS SYSDBA
SELECT NAME, FORCE_LOGGING, LOG_MODE, OPEN_MODE, DATABASE_ROLE FROM V$DATABASE;
RECOVER MANAGED STANDBY DATABASE CANCEL/*Media recovery complete*/;
ALTER DATABASE OPEN;
SELECT NAME, FORCE_LOGGING, LOG_MODE, OPEN_MODE, DATABASE_ROLE FROM V$DATABASE/*OPEN_MODE=READ ONLY*/;
DESC NEW_TABLE;
SELECT * FROM NEW_TABLE;
SELECT NAME, FORCE_LOGGING, LOG_MODE, OPEN_MODE, DATABASE_ROLE FROM V$DATABASE/*NAME=primer*/;
SELECT INSTANCE_NAME FROM V$INSTANCE/*primer2*/;
