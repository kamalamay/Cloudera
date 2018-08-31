# Install Oracle Database RAC 12.2.0.1

## pre-requisite (resolve hostname)
* edit /etc/hosts
  -  Public
  - 192.168.1.1			host01.localdomain		host01
  - 192.168.1.2			host02.localdomain		host02
  - Private
  - 10.10.1.1		host01-priv.localdomain	host01-priv
  - 10.10.1.2		host02-priv.localdomain	host02-priv
  - Virtual
  - 192.168.1.3			host01-vip.localdomain	host01-vip
  - 192.168.1.4			host02-vip.localdomain	host02-vip
  -  SCAN
  - 192.168.1.5		host-scan.localdomain	host-scan
  - 192.168.1.6		host-scan.localdomain	host-scan
  - 192.168.1.7		host-scan.localdomain	host-scan


## pre-requisite (configure kernel) 
* edit /etc/sysctl.conf
  - fs.file-max = 6815744
  - kernel.sem = 250 32000 100 128
  - kernel.shmmni = 4096
  - kernel.shmall = 1073741824
  - kernel.shmmax = 4398046511104
  - kernel.panic_on_oops = 1
  - net.core.rmem_default = 262144
  - net.core.rmem_max = 4194304
  - net.core.wmem_default = 262144
  - net.core.wmem_max = 1048576
  - net.ipv4.conf.all.rp_filter = 2
  - net.ipv4.conf.default.rp_filter = 2
  - fs.aio-max-nr = 1048576
  - net.ipv4.ip_local_port_range = 9000 65500

## pre-requisite (configure security)
* edit /etc/security/limits.d/90-nproc.conf
  - oracle   soft   nofile    1024
  - oracle   hard   nofile    65536
  - oracle   soft   nproc    16384
  - oracle   hard   nproc    16384
  - oracle   soft   stack    10240
  - oracle   hard   stack    32768
  - oracle   hard   memlock    134217728
  - oracle   soft   memlock    134217728

## pre-requisite (create user)
* GROUPADD
  - groupadd -g 54321 oinstall
  - groupadd -g 54322 dba
  - groupadd -g 54323 oper
*USERADD
  - useradd -u 54321 -g oinstall -G dba,oper oracle

## pre-requisite (create bash profile host1)
* edit file /home/oracle/.bash_profile
  - export TMP=/tmp
  - export TMPDIR=$TMP
  - export ORACLE_HOSTNAME=host01.localdomain
  - export ORACLE_UNQNAME=POCRAC
  - export ORACLE_BASE=/u01/app/oracle
  - export GRID_HOME=/u01/app/grid
  - export DB_HOME=$ORACLE_BASE/product/12.2.0/db_1
  - export ORACLE_HOME=$DB_HOME
  - export ORACLE_SID=pocrac1
  - export ORACLE_TERM=xterm
  - export BASE_PATH=/usr/sbin:$PATH
  - export PATH=$ORACLE_HOME/bin:$BASE_PATH
  - export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
  - export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
  - alias grid_env='. /home/oracle/grid_env'
  - alias db_env='. /home/oracle/db_env'

* edit file /home/oracle/grid_env
  - export ORACLE_SID=+ASM1
  - export ORACLE_HOME=$GRID_HOME
  - export PATH=$ORACLE_HOME/bin:$BASE_PATH
  - export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
  - export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

* edit file /home/oracle/db_env
  - export ORACLE_SID=pocrac3
  - export ORACLE_HOME=$DB_HOME
  - export PATH=$ORACLE_HOME/bin:$BASE_PATH
  - export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
  - export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

## pre-requisite (create bash profile host2)
* edit file /home/oracle/.bash_profile
  - export TMP=/tmp
  - export TMPDIR=$TMP
  - export ORACLE_HOSTNAME=host02.localdomain
  - export ORACLE_UNQNAME=POCRAC
  - export ORACLE_BASE=/u01/app/oracle
  - export GRID_HOME=/u01/app/grid
  - export DB_HOME=$ORACLE_BASE/product/12.2.0/db_1
  - export ORACLE_HOME=$DB_HOME
  - export ORACLE_SID=pocrac2
  - export ORACLE_TERM=xterm
  - export BASE_PATH=/usr/sbin:$PATH
  - export PATH=$ORACLE_HOME/bin:$BASE_PATH
  - export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
  - export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
  - alias grid_env='. /home/oracle/grid_env'
  - alias db_env='. /home/oracle/db_env'

* edit file /home/oracle/grid_env
  - export ORACLE_SID=+ASM1
  - export ORACLE_HOME=$GRID_HOME
  - export PATH=$ORACLE_HOME/bin:$BASE_PATH
  - export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
  - export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

* edit file /home/oracle/db_env
  - export ORACLE_SID=pocrac4
  - export ORACLE_HOME=$DB_HOME
  - export PATH=$ORACLE_HOME/bin:$BASE_PATH
  - export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
  - export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

## pre-requisite (format disk for ASM)
* check disk uuid
  - /sbin/scsi_id -g -u -d /dev/sda
  - 36000c29b0642c35a7a376ce005366945
* create rule at /etc/udev/rules.d/99-oracle-asmdevices.rules
  - KERNEL=="sda1", SUBSYSTEM=="block", PROGRAM=="/sbin/scsi_id -g -u -d /dev/$parent", RESULT=="36000c29b0642c35a7a376ce005366945", SYMLINK+="oracleasm/asm-disk1", OWNER="oracle", GROUP="dba", MODE="0660"
  - KERNEL=="sdd", SUBSYSTEM=="block", PROGRAM=="/sbin/scsi_id -g -u -d /dev/$parent", RESULT=="36000c29b0642c35a7a376ce005366945", SYMLINK+="oracleasm/raw-disk2", OWNER="oracle", GROUP="dba", MODE="0660"
  - KERNEL=="sda1", SUBSYSTEM=="block", PROGRAM=="/sbin/scsi_id -g -u -d /dev/$parent", RESULT=="36000c2919c4819c1bdbd79dc03813703", SYMLINK+="oracleasm/raw-disk2", OWNER="oracle", GROUP="dba", MODE="0660"
* change file /etc/scsi_id.config and add parameter:
  - options=-g
* probe new disk
  - /sbin/partprobe /dev/sda1
  - /sbin/partprobe /dev/sdb1
* test disk 
  - /sbin/udevadm test /block/sda/sda1
* reload rules
  - /sbin/udevadm control --reload-rules
* check disk ownership 
  - ls -al /dev/oracleasm/*
  - ls -al /dev/sd*1