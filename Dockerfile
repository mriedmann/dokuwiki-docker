FROM alpine:3.4

ENV DOKUWIKI_VERSION=2016-06-26a
ENV DOKUWIKI_MD5=9b9ad79421a1bdad9c133e859140f3f2

RUN apk add --no-cache \
	php5-common \
	php5-iconv \
	php5-json \
	php5-gd \
	php5-curl \
	php5-xml \
	php5-mysql \
	php5-imap \
	php5-pdo \
	php5-pdo_mysql \
	php5-soap \
	php5-xmlrpc \
	php5-posix \
	php5-mcrypt \
	php5-gettext \
	php5-ldap \
	php5-ctype \
	php5-dom \
    php5-fpm \
	php5-openssl \
	supervisor \
	nginx \
	sqlite \
	tar git wget unzip

RUN cd /tmp/ && \
    wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-${DOKUWIKI_VERSION}.tgz && \
	echo "$DOKUWIKI_MD5  dokuwiki-${DOKUWIKI_VERSION}.tgz" > MD5SUM && md5sum -c MD5SUM && \
	mkdir -p /opt/dokuwiki && \
	cd /opt/dokuwiki/ && \
    tar --strip-components=1 -vxzf /tmp/dokuwiki-${DOKUWIKI_VERSION}.tgz && \
    rm -Rf /tmp/dokuwiki* \
	rm /opt/dokuwiki/install.php

COPY pool.conf /etc/php-fpm.d/pool.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf	
	
WORKDIR /opt/dokuwiki

COPY /conf/* /opt/dokuwiki/conf/

RUN chown -R nginx:nginx /opt/dokuwiki && \
	chown -R nginx:nginx /var/lib/nginx/ && \
	touch /var/run/supervisor.sock && \
	chmod 777 /var/run/supervisor.sock && \
	mkdir /run/nginx

VOLUME ["/opt/dokuwiki/data/","/opt/dokuwiki/lib/plugins/","/opt/dokuwiki/conf/","/opt/dokuwiki/lib/tpl/"]

EXPOSE 80

CMD supervisord




