#!/usr/bin/env bash
if [ -z "$RELEASE_VERSION" ]; then
  echo "env variable RELEASE_VERSION missing. It is ParaSite version"
  exit 1
fi

if [ -z "$ENS_VERSION" ]; then
  echo "env variable ENS_VERSION missing. It is Ensembl version"
  exit 1
fi

if [ -d "/nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION" ]; then
  echo "Deleting the directory /nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION"
  rm -rf /nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION
fi
 
mkdir -p /nfs/public/nobackup/ensweb/live/parasite-mart/release-$RELEASE_VERSION/logs/
mkdir -p /nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION
echo "Creating /nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION/conf/"
cp -r /nfs/public/release/ensweb/live/parasite-mart/release-$RELEASE_VERSION/biomart/conf /nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION/
echo "Creating /nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION/htdocs/"
cp -r /nfs/public/release/ensweb/live/parasite-mart/release-$RELEASE_VERSION/biomart/htdocs /nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION/
echo "Creating /nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION/cgi-bin/"
cp -r /nfs/public/release/ensweb/live/parasite-mart/release-$RELEASE_VERSION/biomart/cgi-bin /nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION/
echo "Creating databases connection at /nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION/conf/registry.xml"
sed -e "s/#PSVERSION#/$RELEASE_VERSION/; s/#ENSVERSION#/$ENS_VERSION/" /nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION/conf/registryURLPointer.xml > /nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION/conf/registry.xml
sed -i "s/<release_version>/release-$RELEASE_VERSION/" /nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION/conf/settings.conf
cd /nfs/public/release/ensweb/live/parasite-mart/release-$RELEASE_VERSION/biomart/
export PERL5LIB=.:$PERL5LIB
./redo.sh "/nfs/incoming/ensweb/live/parasite-mart/release-$RELEASE_VERSION/conf/"
