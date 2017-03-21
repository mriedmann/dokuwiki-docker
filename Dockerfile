FROM alpine:3.4

ENV DOKUWIKI_VERSION=2017-02-19b
ENV DOKUWIKI_MD5=ea11e4046319710a2bc6fdf58b5cda86

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
	php5-zlib \
	php5-openssl \
	supervisor \
	nginx \
	sqlite \
	tar git wget unzip

RUN cd /tmp/ && \
    wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-${DOKUWIKI_VERSION}.tgz && \
	echo "$DOKUWIKI_MD5  dokuwiki-${DOKUWIKI_VERSION}.tgz" > MD5SUM && md5sum -c MD5SUM && \
	mkdir -p /usr/src/dokuwiki && \
	cd /usr/src/dokuwiki && \
    tar --strip-components=1 -vxzf /tmp/dokuwiki-${DOKUWIKI_VERSION}.tgz && \
    rm -Rf /tmp/dokuwiki* && \
	rm /usr/src/dokuwiki/install.php

COPY conf/* /usr/src/dokuwiki/conf/
	
COPY pool.conf /etc/php-fpm.d/pool.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf	

COPY entrypoint.sh /bin/entrypoint

RUN chmod +x /bin/entrypoint && \
	chown -R nginx:nginx /var/lib/nginx/ && \
	touch /var/run/supervisor.sock && \
	chmod 777 /var/run/supervisor.sock && \
	mkdir /run/nginx && \
	mkdir -p /opt/dokuwiki/data && \
    mkdir -p /opt/dokuwiki/lib/plugins && \
	mkdir -p /opt/dokuwiki/conf && \
	mkdir -p /opt/dokuwiki/lib/tpl
	
VOLUME ["/opt/dokuwiki/data/","/opt/dokuwiki/lib/plugins/","/opt/dokuwiki/conf/","/opt/dokuwiki/lib/tpl/"]

EXPOSE 80

ENTRYPOINT ["entrypoint"]
CMD ["supervisord"]




