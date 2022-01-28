#!/bin/bash

# wait for MSSQL server to start
export STATUS=1
i=0

while [[ $STATUS -ne 0 ]] && [[ $i -lt 30 ]]; do
	i=$i+1
	/opt/mssql-tools/bin/sqlcmd -t 1 -U sa -P $SA_PASSWORD -Q "select 1" >> /dev/null
	STATUS=$?
done

if [ $STATUS -ne 0 ]; then 
	echo "Error: MSSQL SERVER took more than thirty seconds to start up."
	exit 1
fi

# echo :setvar MSSQL_DB $MSSQL_DB > /usr/config/param_setup.sql
# echo :setvar MSSQL_USER $MSSQL_USER > /usr/config/param_setup.sql
# echo :setvar MSSQL_PASSWORD $MSSQL_PASSWORD > /usr/config/param_setup.sql
# cat setup.sql >> /usr/config/param_setup.sql

echo "======= MSSQL SERVER STARTED ========" | tee -a /usr/config/config.log
# Run the setup script to create the DB and the schema in the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -d master -i /usr/config/setup.sql

echo "======= MSSQL CONFIG COMPLETE =======" | tee -a /usr/config/config.log
