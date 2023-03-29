#!/usr/bin/env bash
# Script to setup ParaSite staging/live/fallback/archive biomart, usage: ./setup.sh [--archive | --fallback | --staging1 | --staging2]
set -e
LIVE_PATH='live'
DATABASE_HOST='pg-mysql-ps-mart-rel'
DATABASE_PORT='4474'

if [ "$1" = "--archive" ]; then
   LIVE_PATH='live/archive'
   DATABASE_HOST='mysql-ps-archive-mart'
   DATABASE_PORT='4696'
fi

if [ "$1" = "--fallback" ]; then
   DATABASE_HOST='fb1-mysql-ps-mart-rel'
fi

if [ "$1" = "--staging1" ]; then
   LIVE_PATH='staging'
   DATABASE_HOST='mysql-ps-staging-1'
   DATABASE_PORT='4451'
fi

if [ "$1" = "--staging2" ]; then
   LIVE_PATH='staging'
   DATABASE_HOST='mysql-ps-staging-2'
   DATABASE_PORT='4467'
fi

if [ -z "$RELEASE_VERSION" ]; then
  echo "env variable RELEASE_VERSION missing. It is ParaSite version"
  exit 1
fi

if [ -z "$ENS_VERSION" ]; then
  echo "env variable ENS_VERSION missing. It is Ensembl version"
  exit 1
fi

if [ -d "/nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION" ]; then
  echo "Deleting the directory /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION"
  rm -rf /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION
fi
 
mkdir -p /nfs/public/nobackup/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/logs/
mkdir -p /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION
echo "Creating /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/conf/"
cp -r /nfs/public/release/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/biomart/conf /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/
echo "Creating /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/htdocs/"
cp -r /nfs/public/release/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/biomart/htdocs /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/
echo "Creating /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/cgi-bin/"
cp -r /nfs/public/release/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/biomart/cgi-bin /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/
echo "Creating databases connection at /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/conf/registry.xml"
sed -e "s/#PSVERSION#/$RELEASE_VERSION/; s/#ENSVERSION#/$ENS_VERSION/; s/#DATABASE_HOST#/$DATABASE_HOST/; s/#DATABASE_PORT#/$DATABASE_PORT/" /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/conf/registryURLPointer.xml > /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/conf/registry.xml
sed -i "s/<release_version>/release-$RELEASE_VERSION/" /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/conf/settings.conf
sed -i "s/<stage_path>/$LIVE_PATH/" /nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/conf/settings.conf
cd /nfs/public/release/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/biomart/
export PERL5LIB=.:$PERL5LIB
./redo.sh "/nfs/incoming/ensweb/$LIVE_PATH/parasite-mart/release-$RELEASE_VERSION/conf/"
