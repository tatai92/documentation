#!/bin/bash

TARGET='WEBNET@11.235.51.204'
TARGET_DIR='/var/www/sarpi'
TMP_DIR='/tmp/sarpi'
TARBALL='sarpi.tar.bz2'

TAG=$1
if [[ $TAG == '' ]]; then
    echo "Quelle branche souhaitez-vous deployer ? (trunk, LOT1, ...) "
    read -r TAG
fi
if [[ $TAG == '' || $TAG == 'trunk' ]] ; then
    SVN="https://bellatrix.webnet.local/svn/SARP_SARPI_OPTILIA/trunk"
else
    SVN="https://bellatrix.webnet.local/svn/SARP_SARPI_OPTILIA/trunk"
fi

echo "Recuperation des sources"
svn --force export $SVN $TMP_DIR

cd $TMP_DIR

#echo "Recupperation des vendors"
#rm composer.lock && php composer.phar install && rm -rf app/cache/*

echo "Compression des sources"
tar -cvjf $TARBALL *
cd -

echo "Connexion au VPN"
vpnc Webnet.conf

echo "Pre-configuration du server de prod"
ssh $TARGET 'bash -s' < pre_configure_prod.sh $TARGET_DIR

echo "Transfert vers le serveur de prod"
scp -r $TMP_DIR/$TARBALL $TARGET:$TARGET_DIR

echo "Decompression des sources"
ssh $TARGET "cd $TARGET_DIR && tar -xvjf $TARBALL"

echo "Post-configuration du server de prod"
ssh $TARGET 'bash -s' < post_configure_prod.sh $TARGET_DIR

echo "Deconnexion du VPN"
vpnc-disconnect

echo "Suppression de la tarball"
rm -f $TARBALL
rm -rf $TMP_DIR
