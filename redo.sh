#!/bin/bash



if [ -z "$1" ] || [ ! -f "$1" ];then
    echo "Supply a valid registry file (in the config directory)"
    exit 1
else
    export ENSEMBL_MART_CONF_DIR=$(dirname $1)
fi


echo -ne 'n' | perl bin/configure.pl --clean -r "$(basename $1)" || {
    echo "Failed to rerun configure.pl with $1"
    exit 1
}

./restart.sh $ENSEMBL_MART_CONF_DIR
