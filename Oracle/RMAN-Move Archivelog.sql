Moving archivelog PT SIS
------------------------
RMAN> list archivelog all;
RMAN> CROSSCHECK ARCHIVELOG ALL;
RMAN> LIST EXPIRED ARCHIVELOG ALL;
RMAN> delete expired archivelog all;
RMAN> catalog start with '/arch002/backup_arc/20150807_arc_1_304';
...

...
File Name: /arch002/backup_arc/20150807_arc_1_304/1_304998_767885942.arc
File Name: /arch002/backup_arc/20150807_arc_1_304/1_304999_767885942.arc

Do you really want to catalog the above files (enter YES or NO)? YES
cataloging files...
cataloging done

List of Cataloged Files
=======================
File Name: /arch002/backup_arc/20150807_arc_1_304/1_304000_767885942.arc
File Name: /arch002/backup_arc/20150807_arc_1_304/1_304001_767885942.arc
...
File Name: /arch002/backup_arc/20150807_arc_1_304/1_304999_767885942.arc

RMAN> LIST ARCHIVELOG ALL;
...
310270  1    304951  A 07-AUG-2015 15:05:54 /arch002/backup_arc/20150807_arc_1_304/1_304951_767885942.arc
310271  1    304952  A 07-AUG-2015 15:05:55 /arch002/backup_arc/20150807_arc_1_304/1_304952_767885942.arc
...
RMAN>