nama DB: AzizDB
instance primer: AzizDB
instance physical standby: AzizDB2

1. Pada Primary, archive log mode harus enable
SQL> select force_logging from v$database;
SQL> alter database force logging;
SQL> archive log list;

2. buat folder archive di dalam folder /home/prastyo/app/prastyo/oradata/AzizDB sebagai tempat untuk file-file archive

3. Pada Primary set initialization parameter.
SQL> alter system set db_unique_name=AzizDB scope=both;
SQL> alter system set service_names=AzizDB scope=both;
SQL> alter system set log_archive_config='dg_config=(AzizDB,AzizDB2)' scope=both;
SQL> alter system set log_archive_dest_1=' location=/home/prastyo/app/prastyo/oradata/AzizDB/archive valid_for=(ALL_LOGFILES,ALL_ROLES) db_unique_name=AzizDB' scope=both;
SQL> alter system set log_archive_dest_2='service=AzizDB2 valid_for=(ONLINE_LOGFILES,PRIMARY_ROLE) db_unique_name=AzizDB2 lgwr async' scope=both;
SQL> alter system set log_archive_dest_state_1=ENABLE scope=both;
SQL> alter system set log_archive_dest_state_2=ENABLE scope=both;
SQL> alter system set standby_file_management=AUTO scope=both;
SQL> alter system set standby_archive_dest =' location=/home/prastyo/app/prastyo/oradata/AzizDB/archive' scope=both;
SQL> create pfile='/home/prastyo/app/prastyo/oradata/AzizDB/init.ora' from spfile;

4. cek semua datafiles yg ada pada PRIMARY
SQL> select file_name from dba_data_files;
SQL> select file_name from dba_temp_files;
SQL> select group#, member from v$logfile order by group#;

5. create standby logfile dan controlfile
SQL> alter database add standby logfile group 4 '/home/prastyo/app/prastyo/oradata/AzizDB/stby_redo04.log' size 50m;
SQL> alter database add standby logfile group 5 '/home/prastyo/app/prastyo/oradata/AzizDB/stby_redo05.log' size 50m;
SQL> alter database add standby logfile group 6 '/home/prastyo/app/prastyo/oradata/AzizDB/stby_redo06.log' size 50m;
SQL> alter database add standby logfile group 7 '/home/prastyo/app/prastyo/oradata/AzizDB/stby_redo07.log' size 50m;
SQL> alter database create standby controlfile as '/home/prastyo/app/prastyo/oradata/AzizDB/stby_control01.ctl';

--CATATAN KALAU MAU DROP STANDBY LOGFILE: ALTER DATABASE DROP STANDBY LOGFILE GROUP 4;

6. copy semua datafiles dan redo log serta standby control file dan init.ora yang ada pada Primary.

7. lalu pada mesin dari physical standby buat folder yang namanya sama dgn pada primary.
yaitu folder /home/prastyo/app/prastyo/oradata/AzizDB
dan folder adump,bdump,cdump,dpdump,pfile,udump pada folder /home/prastyo/app/prastyo/admin/AzizDB

8. paste semua datafile, logfile dan standby control file dari primary ke physical standby.
di mesin physical standby pd folder /home/prastyo/app/prastyo/oradata/AzizDB

9. pd standby, create instance AzizDB2 (pada physical standby, keadaan awalnya belum ada database dtguard dan blum ada instance AzizDB2)
c:\ oradim -new -sid AzizDB2 -syspwd oracle -startmode manual

10. Pd standby, set init.ora
setting parameter control file
AzizDB2.control_files='/home/prastyo/app/prastyo/oradata/AzizDB/stby_control1.ctl'
AzizDB2.db_unique_name=AzizDB2
AzizDB2.service_names=AzizDB2
AzizDB2.log_archive_config='dg_config=(dtguard,AzizDB2)'
AzizDB2.log_archive_dest_1='location=/home/prastyo/app/prastyo/oradata/AzizDB\archive valid_for=(ALL_LOGFILE,ALL_ROLES) db_unique_name=AzizDB2'
AzizDB2.log_archive_dest_2='service=dtguard valid_for=(ONLINE_LOGFILES,PRIMARY_ROLE) db_unique_name=dtguard'

11. lalu login sqlplus pada standby
c:\ set oracle_sid=AzizDB2
c:\ sqlplus sys/oracle as sysdba
connected to an idle instance
SQL> create spfile from pfile='/home/prastyo/app/prastyo/oradata/AzizDB/init.ora';
SQL> alter database mount;

12. aktifkan phsyical standby database (catatan: jumlah log pada primary dan standby harus sama, kl pada primary ada 7 group maka standby jg hrs 7 group)
proses penerimaan redo data diatur oleh Remote File Server (RFS) dan redo yg diterima diproses oleh Managed Recover Process (MRP)

(i) untuk mengaktifkan standby sebagai foreground process –> Pada Standby
SQL> alter database recover managed standby database;

perintah diatas akan menyebabkan session yg menjalankan seakan-akan menjadi ‘hang'. jika session ditutup, maka MRP juga akan berhenti
untuk membatalkannya gunakan perintah berikut

SQL> alter database recover managed standby database cancel;

(ii) untuk mengaktifkan standby sebagai background process (recommended) –> Pada Standby
SQL> alter database recover managed standby database disconnect from session;

(iii) agar redo data dapat segera diproses tanpa menunggu log switch, jalankan MRP dengan option USING CURRENT LOGFILE –> Pada Standby
SQL> alter database recover managed standby database using current logfile disconnect from session;

13. untuk mengecek sukses tidaknya pengiriman redo lakukan log switch (Pada primary database)
SQL> alter system switch logfile;
SQL> col destination format a25
SQL> col error format a20
SQL> select dest_id, destination, status, error from v$archive_dest;

14. untuk mengecek redo yang diterima sudah diproses atau belum
SQL> select sequence#, applied from v$archived_log;

bila ada yg belum di-applied, maka pastikan bahwa MRP sudah berjalan
SQL> alter database recover managed standby database using current logfile disconnect from session;

JENIS PROTEKSI PADA DATABASE
1. MAXIMUM PROTECTION MODE —->> Kecepatan Transfer Jaringan hrs diatas 100Mb, tidak cocok bila menggunakan WAN
2. MAXIMUM AVAILABITITY MODE —->> Kecepatan Transfer Jaringan hrs diatas 100Mb, tidak cocok bila menggunakan WAN
3. MAXIMUM PERFORMANCE MODE

I. MAXIMUM PROTECTION MODE
Pada parameter LOG_ARCHIVE_DEST_2 membutuhkan nilai LGWR SYNC atau AFFIRM
SQL> alter system set log_archive_dest_2= —->> pada primary
2 ‘service=AzizDB2
3 valid_for=(ONLINE_LOGFILES,PRIMARY_ROLE)
4 db_unique_name=AzizDB2 LGWR SYNC';

SQL> col value format a60
SQL> select value from v$parameter where name='log_archive_dest_2′;
SQL> shutdown immediate;
SQL> startup mount;
SQL> select protection_mode from v$database;
PROTECTION_MODE
———————–
MAXIMUM PERFORMANCE

SQL> alter database set standby database to maximize protection; —> pada primary
SQL> alter database open;

II. MAXIMUM AVAILABILITY MODE
set parameter LOG_ARCHIVE_DEST_2 sama seperti pada MAXIMUM PROTECTION MODE
SQL> conn sys/oracle@dtguard as sysdba
SQL> shutdown immediate;
SQL> startup mount;
SQL> alter database set standby database to maximize availability;
SQL> alter database open;
SQL> select protection_mode, protection_level from v$database;
PROTECTION_MODE PROTECTION_LEVEL
———————- ————————
MAXIMUM AVAILABILITY MAXIMUM AVAILABILITY

Namun jika physical standby database berada pada keadaan shutdown maka yang tampil adalah
SQL> select protection_mode, protection_level from v$database;
PROTECTION_MODE PROTECTION_LEVEL
———————- ————————
MAXIMUM AVAILABILITY RESYNCHRONIZATION

III. MAXIMUM PERFORMANCE MODE
- Merupakan nilai default
- Pada parameter LOG_ARCHIVE_LOG_DEST_2 dpt memakai option ARC atau LGWR ASYNC

SWITCHOVER DAN FAILOVER

I. SWITCHOVER
login ke primary sebagai SYSDBA
SQL> select switchover_status from v$database;
SWITCHOVER_STATUS
————————-
TO STANDBY
status diatas menandakan tidak ada session yang aktif saat ini, lalu lakukan switchover
SQL> alter database commit to switchover to physical standby;

tetapi jika ada session yang masih aktif maka statusnya
SQL> select switchover_status from v$database;
SWITCHOVER_STATUS
————————–
SESSION ACTIVE
jika ada sesion yang aktif maka utk melakukan proses switchover dapat digunakan perintah berikut ini
SQL> alter database commit to switchover to physical standby with session shutdown;
