RMAN>

/export/home/tmp/arcdb/ dari tanggal 8 sep sampe 17 sep

list copy of archivelog from time 'sysdate-36' until time 'sysdate-8';

delete noprompt archivelog from time 'sysdate-36' until time 'sysdate-8';

LIST COPY OF ARCHIVELOG FROM TIME 'TRUNC(SYSDATE-5)' UNTIL TIME 'TRUNC(SYSDATE-4)';

DELETE ARCHIVELOG FROM TIME 'TRUNC(SYSDATE-5)' UNTIL TIME 'TRUNC(SYSDATE-4)';

list archivelog all;
list copy of archivelog until time 'SYSDATE-10';
list copy of archivelog from time 'SYSDATE-10'
list copy of archivelog from time 'SYSDATE-10' until time 'SYSDATE-2';
list copy of archivelog from sequence 1000;
list copy of archivelog until sequence 1500;
list copy of archivelog from sequence 1000 until sequence 1500; 

delete archivelog all;
delete archivelog until time 'SYSDATE-10';
delete archivelog from time 'SYSDATE-10'
delete archivelog from time 'SYSDATE-10' until time 'SYSDATE-2';
delete archivelog from sequence 1000;
delete archivelog until sequence 1500;
delete archivelog from sequence 1000 until sequence 1500;

Note : Also, you can use noprompt statement for do not yes-no question.
delete noprompt archivelog until time 'SYSDATE-10';

RMAN> list archivelog all;
RMAN> crosscheck archivelog all;
RMAN> delete expired archivelog all;

Kalo ga bisa delete di standby DB:
RMAN> delete noprompt force archivelog all;

LIST COPY OF ARCHIVELOG UNTIL TIME 'TRUNC(SYSDATE-9)';
DELETE NOPROMPT COPY OF ARCHIVELOG UNTIL TIME 'TRUNC(SYSDATE-9)';

CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY;