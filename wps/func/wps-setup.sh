# ------------------------
# WPS SETUP
# ------------------------

function wps_setup() {

	# ------------------------
	# REPOS
	# ------------------------
	
	# NGINX
	cat /usr/local/wps/conf/yum/nginx.repo > /etc/yum.repos.d/nginx.repo
	
	# EPEL
	rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
	
	# REMI
	rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
	
	# ------------------------
	# INSTALL
	# ------------------------
	
	## Dependecies
	yum install -y nano wget zip python-setuptools

	## NGINX + MariaDB Client
	yum install -y nginx mariadb
	               
	## PHP
	yum install -y --enablerepo=remi,remi-php56 \
	               php-fpm \
	               php-common \
	               php-opcache \
	               php-pecl-apcu \
	               php-cli \
	               php-pear \
	               php-pdo \
	               php-mysqlnd \
	               php-pgsql \
	               php-pecl-mongo \
	               php-pecl-sqlite \
	               php-pecl-memcache \
	               php-pecl-memcached \
	               php-gd php-mbstring \
	               php-mcrypt php-xml
	               
	## Supervisor
	easy_install supervisor
	easy_install supervisor-stdout
	
	## WP-CLI
	wget -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x /usr/local/bin/wp
	
	# ------------------------
	# CONFIG
	# ------------------------

	cat /usr/local/wps/conf/nginx/nginx.conf > /etc/nginx/nginx.conf
	cat /usr/local/wps/conf/nginx/wordpress.conf > /etc/nginx/conf.d/default.conf
	cat /usr/local/wps/conf/php/php-fpm.conf > /etc/php-fpm.d/www.conf
	cat /usr/local/wps/conf/supervisor/supervisord.conf > /etc/supervisord.conf
	
	# ------------------------
	# OPENSSL
	# ------------------------
	
	mkdir -p /app/ssl
	cd /app/ssl
	
	openssl req -nodes -sha256 -newkey rsa:2048 -keyout localhost.key -out localhost.csr -config /usr/local/wps/conf/nginx/openssl.conf -batch
	openssl rsa -in localhost.key -out localhost.key
	openssl x509 -req -days 365 -in localhost.csr -signkey localhost.key -out localhost.crt

	# ------------------------
	# WORDPRESS
	# ------------------------
	
	if [[  ! -d '/etc/wps/env'  ]]; then
		mkdir -p /etc/wps/env
		env | grep 'DATABASE_URL'.* | cut -d= -f2 > /etc/wps/env/DATABASE_URL
	fi
	
	mkdir -p /app/wordpress
	cd /app/wordpress
	
	wp --allow-root core download	
	cat /usr/local/wps/conf/wordpress/wp-config.php > /app/wp-config.php
	cat /usr/local/wps/conf/wordpress/db.php > /app/wordpress/db.php

 	chown -R nginx:nginx /app/wordpress
 	chown -R nginx:nginx /app/wp-config.php
 	chmod -R 755 /app/wordpress
 	chmod -R 755 /app/wp-config.php

}
