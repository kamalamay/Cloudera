/*TUTORIAL ORACLE DATA GUARD DI SISTEM OPERASI MICROSOFT WINDOWS
Asumsi:
1. Dua sistem operasi Windows 7 32 bit yang diinstall di 2 mesin virtual (VMWare, VirtualBox) dengan spesifikasi yang sama, mungkin beda juga boleh hehe
2. Virtual 1 dinamai primer dan virtual 2 dinamai bali, IP primer: 192.168.115.145, IP bali: 192.168.115.146. Usahakan menggunakan IP static
3. Kedua Windows tersebut di-install Oracle 11gR2 32-bit, primer di-install Oracle database enterprise lengkap, bali di-install Oracle database enterprise tetapi SOFTWARE ONLY
4. Nama instance dan nama database pada komputer primer=primer
5. Peng-install-an Oracle di C:\ora
*/
--Pada primer masuk sebagai sys lewat cmd
SQLPLUS SYS/PWDSYS@192.168.115.145:1521/primer AS SYSDBA
SHOW USER/*Untuk memastikan user siapa yang sedang dipakai*/;
SELECT NAME, FORCE_LOGGING, LOG_MODE, OPEN_MODE, DATABASE_ROLE FROM V$DATABASE/*Untuk melihat spesifikasi/informasi dari database*/;
ALTER DATABASE FORCE LOGGING/*Untuk mengaktifkan FORCE LOGGING*/;

--apabila LOG_MODE=NOARCHIVELOG, set menjadi ARCHIVELOG dengan perintah:
SHUTDOWN IMMEDIATE/*Mematikan database*/;
STARTUP MOUNT/*Me-mount database*/;
ALTER DATABASE ARCHIVELOG/*Mengaktifkan mode archivelog*/;
ALTER DATABASE OPEN/*Membuka database setelah mount*/;
SELECT NAME, FORCE_LOGGING, LOG_MODE, OPEN_MODE, DATABASE_ROLE FROM V$DATABASE/*Untuk melihat spesifikasi/informasi dari database*/;
SELECT NAME FROM V$DATAFILE/*Melihat datafile yang dimiliki*/;
SELECT NAME FROM V$TEMPFILE/*Melihat temp*/;
SELECT TABLESPACE_NAME FROM DBA_TABLESPACES/*Melihat tablespace*/;
SELECT NAME FROM V$CONTROLFILE/*Melihat controlfiles*/;
SELECT MEMBER FROM V$LOGFILE/*Melihat logfile*/;

--Buatlah folder untuk menampung archivelog di direktori oradata primer, misalnya dengan nama C:\ora\oradata\primer\ARCHIVED_LOGS

ARCHIVE LOG LIST/*Melihat archive log aktif atau tidak dan di direktori mana archive log itu tersimpan*/;

/*Gandakan passwordfile primer untuk nanti diletakkan di standby database (bali)
Passwordfile tersebut ada di C:\ora\product\11.2.0\db_home1\database\PWDprimer.ora
Gandakan passwordfile itu dan ganti nama menjadi PWDbali.ora*/
SHOW PARAMETER SPFILE/*Melihat dimana letak SPFILE*/;

/*Lakukan konfigurasi dataguard, konfigurasi ini saya temukan di ebook Oracle dan ini berhasil
Tapi sebaiknya backup dulu SPFILE aslinya*/
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
startup force/*Start database setelah konfigurasi dataguard di primer*/;
SELECT NAME, FORCE_LOGGING, LOG_MODE, OPEN_MODE, DATABASE_ROLE FROM V$DATABASE/*Untuk melihat spesifikasi/informasi dari database*/;
ALTER SYSTEM ARCHIVE LOG CURRENT/*Membuat archive log untuk keadaan saat ini, setelah ini dieksekusi coba deh liat folder C:\ora\oradata\primer\ARCHIVED_LOGS\ harusnya ada archive log muncul di folder itu*/;
SELECT * FROM V$BACKUP/*Melihat kondisi backup, pasti nonaktif*/;
ALTER DATABASE BEGIN BACKUP/*Lakukan hot backup*/;
SELECT * FROM V$BACKUP/*Melihat kondisi backup, pasti aktif*/;
--Copy semua file DBF yang ada di C:\ora\oradata\primer\ ke C:\BACKUP, sebelumnya buat dulu direktori C:\BACKUP\
ALTER DATABASE END BACKUP/*Hentikan hot backup*/;
SELECT * FROM V$BACKUP/*Melihat kondisi backup, pasti nonaktif*/;
ALTER DATABASE CREATE STANDBY CONTROLFILE AS 'C:\BACKUP\CONTROL01.CTL'/*Membuat controlfile untuk standby database (bali) di direktori C:\BACKUP\*/;
/*
Gandakan standby controlfile itu menjadi 3 buah standby controlfile.
Masuk ke direktori C:\BACKUP\, copy CONTROL01.CTL kemudian paste dan rename menjadi CONTROL02.CTL, ulangi sampai tersedia file CONTROL01.CTL, CONTROL02.CTL, CONTROL03.CTL.
Pindahkan passwordfile C:\ora\product\11.2.0\db_home1\database\PWDbali.ora ke C:\BACKUP\
*/

--Membuat instance baru bernama bali di komputer bali, lakukan perintah ini di cmd tanpa masuk SQLPLUS:
oradim -new -sid bali

/*
Lalu pastikan service OracleServicebali running, jika belum ada TNSListener-nya buatlah sendiri, jika ada pastikan koneksi antardatabase dengan cara lakukan perintah tnsping via CMD, tanpa masuk SQLPLUS.
primer:*/
tnsping 192.168.115.146:1521/bali
/*harusnya hasilnya OK
bali:*/
tnsping 192.168.115.145:1521/primer
/*harusnya hasilnya OK
Untuk masalah TNSListener yang masih error cobalah menggunakan fasilitas net manager bawaan dari Oracle atau cari di Google. Pokoknya harus konek satu sama lain.
*/

/*
Pindahkan semua file yang ada di C:\BACKUP\ ke komputer bali C:\ora\oradata\bali\
PWDbali.ora diletakkan di C:\ora\product\11.2.0\db_home1\database\
Masuk ke C:\ora\product\11.2.0\db_home1\database\ lalu buat pfile dengan membuka notepad lalu ketikkan db_name=primer lalu simpan dengan nama initbali.ora.
Buatlah folder untuk menampung archivelog di direktori oradata bali, misalnya dengan nama C:\ora\oradata\bali\ARCHIVED_LOGS
*/

SQLPLUS SYS/PWDSYS@192.168.115.145:1521/primer AS SYSDBA
CREATE SPFILE FROM PFILE/*Membuat spfile dari pfile*/;
startup nomount/*Menyalakan database dengan posisi nomount*/;

--Lakukan konfigurasi dataguard pada komputer bali sebagai standby database
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
ALTER SYSTEM SET LOCAL_LISTENER=bali scope=spfile;
STARTUP NOMOUNT FORCE/*startup nomount setelah konfigurasi*/;
create pfile from spfile/*Membuat pfile dari spfile yang telah dikonfigurasi*/;
ARCHIVE LOG LIST/*Melihat archive log aktif atau tidak dan di direktori mana archive log itu tersimpan, harusnya sudah enable dan direktorinya terarah ke C:\ora\oradata\bali\ARCHIVED_LOGS\*/;
STARTUP MOUNT/*Me-mount database*/;

--setelah database mount, coba cek statusnya dgn cara:
SELECT NAME, FORCE_LOGGING, LOG_MODE, OPEN_MODE, DATABASE_ROLE FROM V$DATABASE/*Untuk melihat spesifikasi/informasi dari database*/;
RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION/*Melakukan recover sebagai standby database, hasil output harusnya Media recovery complete*/;

--Nah, coba lakukan modifikasi pada database primer. Harusnya ketika database primer termodifikasi baik DDL maupun DML, archive log akan terbuat baru dan tertransfer ke standby database. Jika archive log tidak tertransfer, coba lakukan dengan perintah:
alter system archive log current/*Membuat archive log terkini*/;

--atau dengan perintah:
alter system switch logfile/*Memindahkan archive log ke standby database secara paksa*/;

--Jika archive log terkirim dengan ditandai dengan perintah ARCHIVE LOG LIST; atau dilihat di folder C:\ora\oradata\bali\ARCHIVED_LOGS\, maka tandanya berhasil. Nah, untuk memeriksa keberhasilannya coba buka database standby (bali) dengan cara:
RECOVER MANAGED STANDBY DATABASE CANCEL/*Menghentikan proses dataguard*/;
ALTER DATABASE OPEN/*Membuka database*/;

--Setelah itu, periksalah database yang sudah dimodifikasi.
--Kesimpulannya adalah menggandakan/menyalin database dari primer ke standby melalui archive log. Posisi standby database adalah dengan kondisi mount saja. Sedangkan database primer dengan kondisi mount dan open. Kedua database memiliki db_name yang sama, namun memiliki db_unique_name yang berbeda. Sekian, tepuk tangan prok-prok-prok.
/*
Salam,
Aziz Prastyo Wibowo
*/