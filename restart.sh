#!/bin/bash

if [ -z "$APACHE_HOME" ]; then
  if type httpd 2>/dev/null; then
    echo "Using default httpd at `which httpd`"
    httpd -k restart -d $PWD -f $1/httpd.conf
    exit 0
  else 
    echo "Please set APACHE_HOME to the location of your Apache installation" 1>&2
    exit 1
  fi
fi
export PERL5LIB=${APACHE_HOME}/lib/site_perl
# Restart apache server
echo "Restarting Apache..."
${APACHE_HOME}/bin/httpd -k restart -d $PWD -f $PWD/conf/httpd.conf 
