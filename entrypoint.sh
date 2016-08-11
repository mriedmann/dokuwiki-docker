#!/bin/sh

if [ ! -e /opt/dokuwiki/index.php ]
then
	yes n | cp -r -i /usr/src/dokuwiki/* /opt/dokuwiki/
	chown -R nginx:nginx /opt/dokuwiki
fi

exec "$@"