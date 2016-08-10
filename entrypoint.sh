#!/bin/sh

if [ ! -e /opt/dokuwiki/index.php ]
then
	cp -r /usr/src/dokuwiki/* /opt/dokuwiki/
	chown -R nginx:nginx /opt/dokuwiki
fi

exec "$@"