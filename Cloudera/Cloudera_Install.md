# Cloudera Installation tutorial


## pre-requisite (shake hand)

* at source generate ssh-keygen
  - $ ssh-keygen -t rsa
* copy RSA_ID
  - ssh-copy-id -i /home/clouderainstall/.ssh/id_rsa.pub clouderainstall@cloudera01
  - ssh-copy-id -i /home/clouderainstall/.ssh/id_rsa.pub clouderainstall@cloudera02
  - ssh-copy-id -i /home/clouderainstall/.ssh/id_rsa.pub clouderainstall@cloudera03
  - ssh-copy-id -i /home/clouderainstall/.ssh/id_rsa.pub clouderainstall@bakcloudera03
  - ssh-copy-id -i /home/clouderainstall/.ssh/id_rsa.pub clouderainstall@talend01
  - ssh-copy-id -i /home/clouderainstall/.ssh/id_rsa.pub clouderainstall@cloudera05
  - ssh-copy-id -i /home/clouderainstall/.ssh/id_rsa.pub clouderainstall@cloudera06
  - ssh-copy-id -i /home/clouderainstall/.ssh/id_rsa.pub clouderainstall@cloudera07

## pre-requisite (download and install java, mysql connector)
* download java
  - wget http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.rpm?AuthParam=1529219456_b42e4bc703370e93d49289de4304f238
* rename downloaded file
  - mv http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.rpm?AuthParam=1529219456_b42e4bc703370e93d49289de4304f238 jdk-8u171-linux-x64.rpm
* copy to another server
  - scp jdk-8u171-linux-x64.rpm clouderainstall@cloudera02:/home/clouderainstall/jdk-8u171-linux-x64.rpm

* remove openjdk
  - yum remove java
* install jdk1.8 oracle
  - yum install jdk-8u171-linux-x64.rpm

* download mysql connector
  - mkdir -p /usr/share/java/
  - wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz
  - tar -xzvf mysql-connector-java-5.1.46.tar.gz
  - cp mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar
* or copy from another server
  - scp mysql-connector-java-5.1.46-bin.jar clouderainstall@cloudera02:/home/clouderainstall/mysql-connector-java-5.1.46-bin.jar


## pre-requisite (resolve hostname)
* edit /etc/hosts
`<
* 192.168.1.1 cloudera01 cloudera01
* 192.168.1.2 cloudera02 cloudera02
* 192.168.1.3 cloudera03 cloudera03
>`

## pre-requisite (create user)

* create new user and group
useradd -g wheel -mn clouderainstall

* add user to wheel group, or sudoers

`< 
## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL
%group ALL=(ALL)       ALL
## Same thing without a password
%wheel  ALL=(ALL)       NOPASSWD: ALL
%group	ALL=(ALL)       NOPASSWD: ALL
>`

## pre-requisite (install repository database)
* create mariadb repo at /etc/yum.repos.d/mariadb.repo
`<
[mariadb]
name = MariaDB-5.5.60
baseurl=https://downloads.mariadb.com/MariaDB/mariadb-5.5.60/yum/rhel73-amd64/
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
>`

!install mariadb
yum install mariadb-server
!start mysql/mariadb
systemctl start mysql

!create user database
create database scm DEFAULT CHARACTER SET utf8;
grant all on scm.* TO 'scm'@'%' IDENTIFIED BY 'scm';
grant all on scm.* TO 'scm'@'localhost' IDENTIFIED BY 'scm';
grant all on scm.* TO 'scm'@'192.168.129.49' IDENTIFIED BY 'scm';


create database rman DEFAULT CHARACTER SET utf8;
grant all on rman.* TO 'rman'@'%' IDENTIFIED BY 'rman';
grant all on rman.* TO 'rman'@'localhost' IDENTIFIED BY 'rman';
grant all on rman.* TO 'rman'@'192.168.129.49' IDENTIFIED BY 'rman';

create database hive DEFAULT CHARACTER SET utf8;
grant all on hive.* TO 'hive'@'%' IDENTIFIED BY 'hive';
grant all on hive.* TO 'hive'@'localhost' IDENTIFIED BY 'hive';
grant all on hive.* TO 'hive'@'192.168.129.49' IDENTIFIED BY 'hive';

create database oozie DEFAULT CHARACTER SET utf8;
grant all on oozie.* TO 'oozie'@'%' IDENTIFIED BY 'oozie';
grant all on oozie.* TO 'oozie'@'localhost' IDENTIFIED BY 'oozie';
grant all on oozie.* TO 'oozie'@'192.168.129.49' IDENTIFIED BY 'oozie';

create database hue DEFAULT CHARACTER SET utf8;
grant all on hue.* TO 'hue'@'%' IDENTIFIED BY 'hue';
grant all on hue.* TO 'hue'@'localhost' IDENTIFIED BY 'hue';
grant all on hue.* TO 'hue'@'192.168.129.49' IDENTIFIED BY 'hue';

grant all on scm.* TO 'scm'@'192.168.129.52' IDENTIFIED BY 'scm';
grant all on rman.* TO 'rman'@'192.168.129.52' IDENTIFIED BY 'rman';
grant all on hive.* TO 'hive'@'192.168.129.52' IDENTIFIED BY 'hive';
grant all on oozie.* TO 'oozie'@'192.168.129.52' IDENTIFIED BY 'oozie';
grant all on hue.* TO 'hue'@'192.168.129.52' IDENTIFIED BY 'hue';

create database scm3 DEFAULT CHARACTER SET utf8;
grant all on scm3.* TO 'scm3'@'%' IDENTIFIED BY 'scm3';
grant all on scm3.* TO 'scm3'@'localhost' IDENTIFIED BY 'scm3';
grant all on scm3.* TO 'scm3'@'192.168.129.51' IDENTIFIED BY 'scm3';

create database scm3 DEFAULT CHARACTER SET utf8;
grant all on scm3.* TO 'scm3'@'%' IDENTIFIED BY 'scm3';
grant all on scm3.* TO 'scm3'@'localhost' IDENTIFIED BY 'scm3';
grant all on scm3.* TO 'scm3'@'192.168.129.52' IDENTIFIED BY 'scm3';

#install webserver
yum install httpd

#create cm and cdh repo (local)
!download cm dari archive.cloudera.com ke directory /var/www/html
wget -rnp http://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14.3/
wget -rnp http://archive.cloudera.com/cdh5/parcels/5.14.2.3/CDH-5.14.2-1.cdh5.14.2.p0.3-el7.parcel

!buat repo list di /etc/yum.repos.d/cm5.repo

[cloudera-manager]
# Packages for Cloudera Manager, Version 5, on RedHat or CentOS 6 x86_64
name=Cloudera Manager
baseurl=http://192.168.129.49/cm5/redhat/7/x86_64/cm/5.14.3/
gpgkey =http://192.168.129.49/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera
gpgcheck = 0

!repolist-cloudera-manager
[cloudera-manager]
# Packages for Cloudera Manager, Version 5, on RedHat or CentOS 6 x86_64
name=Cloudera Manager
baseurl=http://192.168.129.49/cm5/redhat/7/x86_64/cm/5.14.3/
gpgkey =http://192.168.129.49/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera
gpgcheck = 0

!repolist_local_centos
[CentOS-7]
name=CentOS-7 x86_64
baseurl=file:///media/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY
gpgcheck=0 
enabled=1 


[CentOS-7-IP]
name=CentOS-7 x86_64
metadata_expire=-1
gpgcheck=1
cost=500
baseurl=http://192.168.129.49/centos2/Packages
gpgkey =http://192.168.129.49/centos2/RPM-GPG-KEY-CentOS-7
enabled=1 

##############

!test http nya jalan 
curl http://192.168.129.49/cm5/redhat/7/x86_64/cm/5.14.3/
yum repolist
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
repo id                   repo name                                       status
base/7/x86_64             CentOS-7 - Base                                 9,911
cloudera-manager          Cloudera Manager                                    7
extras/7/x86_64           CentOS-7 - Extras                                 313
mariadb                   MariaDB-5.5.60                                     22
openlogic/7/x86_64        CentOS-7 - openlogic packages for x86_64           97
updates/7/x86_64          CentOS-7 - Updates                                695
repolist: 11,045

#install cloudera-scm-server
yum install cloudera-manager-server cloudera-manager-daemon
!test database schema : All done, your SCM database is configured correctly!
/usr/share/cmf/schema/scm_prepare_database.sh mysql scm3 scm3 scm3

/usr/share/cmf/schema/scm_prepare_database.sh mysql -h 192.168.129.49 scm3 scm3 scm3

!start cloudera scm-server
systemctl start cloudera-scm-server

!check cloudera scm-server log
tail -100f /var/log/cloudera-scm-server/cloudera-scm-server.log


!bego dah ke diri nya sendiri aja lambat

#install cloudera agent
!login ke http://ipclouderaserver:7180
!masukin ip server yang mau di install *kalau di cloud pastiin ip nya private bukan ip public nya
!parcels nya hapus ganti jadi http://192.168.129.49/cdh5/parcels/5.14.2.3/
!gpkey pake yang http://192.168.129.49/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera
!pake rsakey dari user yang udah shakehand tadi (clouderainstall)

!pilih custom service (HDFS, Yarn only)
!deploy as document https://www.cloudera.com/documentation/enterprise/5-14-x/topics/cm_ig_host_allocations.html#host_role_assignments

!install service yang lain, tanya ke tim nya koh iwan :P

!install spark2 https://www.cloudera.com/documentation/spark2/2-2-x/topics/spark2_installing.html
download jar ke /opt/cloudera/csd
sudo chown cloudera-scm:cloudera-scm /opt/cloudera/csd/
sudo chmod 644 /opt/cloudera/csd/
sudo systemctl restart cloudera-scm-server
!add parcels repository http://archive.cloudera.com/spark2/parcels/2.2.0.cloudera2/
!atau kalau gak bisa internet download ke /var/www/html

