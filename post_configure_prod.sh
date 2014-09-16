#!/bin/bash

DIR=$1

echo "Creation des repertoires de log et de cache"
mkdir $DIR/app/cache
mkdir $DIR/app/logs

mkdir -p $DIR/web/uploads/documents
mkdir -p $DIR/web/uploads/docutheque
mkdir -p $DIR/web/uploads/echange_document

sudo cp -R $DIR"_old"/web/uploads $DIR/web/
sudo cp $DIR"_old"/app/config/parameters_prod.yml $DIR/app/config/parameters_prod.yml
sudo cp $DIR"_old"/app/config/parameters_dev.yml $DIR/app/config/parameters_dev.yml
sudo cp $DIR"_old"/app/config/parameters_test.yml $DIR/app/config/parameters_test.yml

echo "Mise a jour des droits"
#chown -R www-data:www-data $DIR
sudo chmod -R 0777 $DIR/app/logs
sudo chmod -R 0777 $DIR/app/cache
sudo chmod -R 0777 $DIR/web/uploads
sudo chmod +x $DIR/bin/wkhtmltopdf_32 $DIR/bin/wkhtmltopdf_64

echo "Mise a jour du cache symfony"
sudo chmod u+x $DIR/app/console
sudo chmod u+x $DIR/cc

echo "Generation Doctrine + assets + CC"
cd $DIR
#chown -R www-data:www-data $DIR/
php app/console assets:install web
sudo ./cc
