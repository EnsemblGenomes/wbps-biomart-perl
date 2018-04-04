#!/bin/bash

if [ -z "$MODPERL_PREFIX" ]; then
   export MODPERL_PREFIX=/nfs/public/rw/ensembl/apache-perlbrew
fi

reg=$1
defreg="./conf/registryURLPointer.xml"
if [ -z "$reg" ]; then
    reg=$defreg
fi
reg=$(readlink -f $reg)

echo -ne 'n' | perl bin/configure.pl --clean -r $reg || {
    echo "Failed to rerun configure.pl with $reg"
    exit 1
}

./restart.sh
