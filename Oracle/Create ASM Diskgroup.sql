Create ASM Diskgroup
--------------------
Add disk, minimal 2 disk yah,
restart OS,
# fdisk -l
# fdisk /dev/sde1 && fdisk /dev/sdf1
# fdisk -l
# /etc/init.d/oracleasm createdisk VOL5 /dev/sde1 && /etc/init.d/oracleasm createdisk VOL5 /dev/sde1
# chown grid:asmadmin /dev/sde1 && chown grid:asmadmin /dev/sdf1 && chmod 660 /dev/sde1 && chmod 660 /dev/sdf1
$ rlwrap sqlplus sys as sysasm
SQL> CREATE DISKGROUP ARC NORMAL REDUNDANCY FAILGROUP VOL4 DISK 'ORCL:VOL4' FAILGROUP VOL5 DISK 'ORCL:VOL5';

Diskgroup created.

SQL> !asmcmd
ASMCMD> lsdg
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  NORMAL  N         512   4096  1048576      4094     3992                0            1996              0             N  ARC/
MOUNTED  NORMAL  N         512   4096  1048576      6141     1931             2047             -58              0             N  DATA/
ASMCMD> exit

SQL>

Catatan:
NORMAL REDUNDANCY - Two-way mirroring, requiring two failure groups.
HIGH REDUNDANCY - Three-way mirroring, requiring three failure groups.
EXTERNAL REDUNDANCY - No mirroring for disks that are already protected using hardware mirroring or RAID. If you have hardware RAID it should be used in preference to ASM redundancy, so this will be the standard option for most installations.