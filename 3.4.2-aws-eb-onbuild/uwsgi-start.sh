#!/bin/bash

cd /var/app

. bin/activate

# Django support
if cat requirements.txt | grep -q -i Django && [ -z "$WSGI_PATH" ]; then
	WSGI_PATH=`find /var/app | egrep '/var/app/[^/]+/wsgi.py'`
fi

# Flask support
if cat requirements.txt | grep -q -i Flask && [ -z "$WSGI_MODULE" ]; then
	WSGI_MODULE=application:app
fi

[ -n "$WSGI_MODULE" ] && UWSGI_MODULE="--module $WSGI_MODULE"

# defaulting to application.py if not explicitly set
[ -z "$WSGI_PATH" ] && WSGI_PATH=application.py

uwsgi --http :8080 --chdir /var/app --wsgi-file $WSGI_PATH $UWSGI_MODULE --master --processes $UWSGI_NUM_PROCESSES --threads $UWSGI_NUM_THREADS --uid $UWSGI_UID --gid $UWSGI_GID --logto2 $UWSGI_LOG_FILE

