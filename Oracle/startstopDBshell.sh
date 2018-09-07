vi stopDB.sh
############
#!/bin/sh
source /home/oraprod/PROD/12.1.0/PROD_ebsexa.env
/home/oraprod/PROD/12.1.0/bin/lsnrctl stop PROD
/home/oraprod/PROD/12.1.0/bin/sqlplus / as sysdba << EOF
SHU IMMEDIATE;
EXIT;
EOF

vi startDB.sh
#############
#!/bin/sh
source /home/oraprod/PROD/12.1.0/PROD_ebsexa.env
/home/oraprod/PROD/12.1.0/bin/lsnrctl start PROD
/home/oraprod/PROD/12.1.0/bin/sqlplus / as sysdba << EOF
STARTUP;
EXIT;
EOF

Atau
####
dbstart $ORACLE_HOME
dbshut $ORACLE_HOME