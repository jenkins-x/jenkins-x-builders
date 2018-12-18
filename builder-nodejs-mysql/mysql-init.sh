#!/bin/sh -eu

mysqld --initialize-insecure
mysqld --user=root &

# Wait at max 60 seconds for it to start up
	i=0
	max=60
	while [ $i -lt $max ]; do
		if echo 'SELECT 1' |  mysql -uroot  > /dev/null 2>&1; then
			break
		fi
		echo "Initializing ..."
		sleep 1s
		i=$(( i + 1 ))
	done

echo "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;" | mysql -uroot
echo "GRANT ALL ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION ;" | mysql -uroot
echo "FLUSH PRIVILEGES ;" | mysql -uroot
echo "CREATE SCHEMA \`${MYSQL_DATABASE}\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | mysql -uroot