#!/bin/bash

DIR=$1

echo "Suppression de la precedente sauvegarde"
sudo rm -r $DIR"_old"
echo "Suppression du cache de la version courante"
sudo rm -r $DIR"/app/cache/*" $DIR"/app/logs/*"
echo "Sauvegarde de la version courante"
mv $DIR $DIR"_old"
mkdir $DIR
