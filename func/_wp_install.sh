function wps_wp_install() {
	
	## ENV SETUP
	mkdir -p /etc/wps/env
	env > /etc/wps/env.sh

	## DATABASE URL
	env | grep 'DATABASE_URL'.* | cut -d= -f2 > /etc/wps/env/DATABASE_URL
	
	## WP INSTALL
	mkdir -p /app/wordpress
	cd /app/wordpress
	
	wp --allow-root core download
	if [ ! $? -eq 0 ]; then 
	wget https://wordpress.org/latest.zip
	unzip *.zip && rm -f *.zip
	mv wordpress/* $(pwd)
	rm -rf wordpress
	fi
	
	cat $WPS/conf/wordpress/wp-config.php > /app/wp-config.php
	cat $WPS/conf/wordpress/db.php > /app/wordpress/db.php
	
# 	wp --allow-root core install \
# 	   --title=WP-STACK \
# 	   --url=http://$WP_URL \
# 	   --admin_name=$WP_USER \
# 	   --admin_email=$WP_MAIL \
# 	   --admin_password=$WP_PASS 
		
	## SSL CERT.
	mkdir -p /app/ssl
	cd /app/ssl
	
	cat $WPS/conf/nginx/openssl.conf | sed "s/localhost/$WP_URL/g" > openssl.conf
	openssl req -nodes -sha256 -newkey rsa:2048 -keyout app.key -out app.csr -config openssl.conf -batch
	openssl rsa -in app.key -out app.key
	openssl x509 -req -days 365 -in app.csr -signkey app.key -out app.crt	
	rm -f openssl.conf
	
	## FIX PERMISSIONS
	chown nginx:nginx -R /app/wordpress && chmod 755 -R /app/wordpress
	chown nginx:nginx /app/wp-config.php && chmod 755 /app/wp-config.php
	
}