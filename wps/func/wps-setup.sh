# ------------------------
# WORDPRESS INSTALL
# ------------------------

function wps_setup() {
	
	
	mkdir -p /app/wordpress
	cd /app/wordpress
	
	wp --allow-root core download	
	cat /etc/env | grep 'DATABASE_URL'.* | cut -d= -f2 > /app/env/database_url
	cat /usr/local/wps/conf/wordpress/wp-config.php > /app/wp-config.php
	cat /usr/local/wps/conf/wordpress/db.php > /app/wordpress/db.php

 	chown -R nginx:nginx /app/wordpress
 	chown -R nginx:nginx /app/wp-config.php
 	chmod -R 755 /app/wordpress
 	chmod -R 755 /app/wp-config.php
}