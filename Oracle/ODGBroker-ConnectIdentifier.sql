DGMGRL> switchover to 'BDG'
Performing switchover NOW, please wait...
New primary database "BDG" is opening...
Operation requires shutdown of instance "jkt" on database "JKT"
Shutting down instance "jkt"...
ORA-01109: database not open

Database dismounted.
ORACLE instance shut down.
Operation requires startup of instance "jkt" on database "JKT"
Starting instance "jkt"...
Unable to connect to database
ORA-12514: TNS:listener does not currently know of service requested in connect descriptor

Failed.
Warning: You are no longer connected to ORACLE.

Please complete the following steps to finish switchover:
        start up and mount instance "jkt" of database "JKT"

DGMGRL> show database 'JKT' StaticConnectIdentifier
ORA-03135: connection lost contact
Process ID: 3246
Session ID: 145 Serial number: 1

Configuration details cannot be determined by DGMGRL
DGMGRL> connect sys/oracle789
Connected.
DGMGRL> show database 'JKT' StaticConnectIdentifier
  StaticConnectIdentifier = '(DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1521))(CONNECT_DATA=(SERVICE_NAME=JKT_DGMGRL)(INSTANCE_NAME=jkt)(SERVER=DEDICATED)))'
DGMGRL> show database 'BDG' StaticConnectIdentifier
  StaticConnectIdentifier = '(DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1521))(CONNECT_DATA=(SERVICE_NAME=BDG_DGMGRL)(INSTANCE_NAME=bdg)(SERVER=DEDICATED)))'
DGMGRL>

edit database 'JKT' set property
StaticConnectIdentifier='(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=jakarta.indonesia.com)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=JKT)(INSTANCE_NAME=jkt)(SERVER=DEDICATED)))';
edit database 'BDG' set property
StaticConnectIdentifier='(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=bandung.indonesia.com)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=BDG)(INSTANCE_NAME=bdg)(SERVER=DEDICATED)))';

DGMGRL> show configuration

Configuration - KotaDR

  Protection Mode: MaxPerformance
  Databases:
    JKT - Primary database
    BDG - Physical standby database

Fast-Start Failover: DISABLED

Configuration Status:
SUCCESS

DGMGRL> switchover to 'BDG'
Performing switchover NOW, please wait...
New primary database "BDG" is opening...
Operation requires shutdown of instance "jkt" on database "JKT"
Shutting down instance "jkt"...
ORA-01109: database not open

Database dismounted.
ORACLE instance shut down.
Operation requires startup of instance "jkt" on database "JKT"
Starting instance "jkt"...
ORACLE instance started.
Database mounted.
Switchover succeeded, new primary is "BDG"
DGMGRL>