FROM php:8.0-apache

RUN apt-get update && apt-get upgrade -y && apt-get install -y libpq-dev libmemcached-dev zlib1g-dev libpng-dev libwebp-dev libjpeg62-turbo-dev libxpm-dev libfreetype6-dev libzip-dev unzip git tzdata libxml2-dev libapache2-mod-evasive gettext && apt-get autoremove -y
RUN apt-get install -y wget
RUN pecl install memcached xdebug igbinary
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_pgsql pgsql gd zip exif soap gettext mysqli
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-enable memcached
RUN docker-php-ext-enable xdebug
RUN docker-php-ext-enable igbinary
RUN docker-php-ext-enable exif
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod ssl
RUN a2enmod evasive
RUN TEMP_DEB="$(mktemp)" && wget -O "$TEMP_DEB" 'http://security.ubuntu.com/ubuntu/pool/universe/a/apache2/libapache2-mod-proxy-html_2.4.7-1ubuntu4.22_amd64.deb' && dpkg -i "$TEMP_DEB" && rm -f "$TEMP_DEB"

# MCrypt :(
#RUN apt-get install -y  gcc make autoconf libc-dev pkg-config libmcrypt-dev
#RUN pecl install mcrypt
#RUN docker-php-ext-enable mcrypt

#Certbot
#RUN apt-get update && apt-get install -y certbot python-certbot-apache

# Restarting apache
RUN service apache2 restart
RUN mkdir -p /var/php-session
RUN chmod -Rf 777 /var/php-session

# Group to write in host folders
RUN addgroup --gid 1024 docker-apache
RUN usermod -a -G docker-apache www-data

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Node
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash -
RUN apt-get -y install nodejs
RUN npm install

# Timezone
ENV TZ 'America/Sao_Paulo'
RUN echo $TZ > /etc/timezone
RUN rm /etc/localtime
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

# Apache as reverse proxy
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN service apache2 restart
