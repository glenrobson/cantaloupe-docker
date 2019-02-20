#!/bin/bash

echo "Starting cron"
sudo cron

echo "Updating Cantaloupe admin pass"
sudo sed -i "s/^endpoint.admin.secret =.*$/endpoint.admin.secret = $CANTALOUPE_ADMIN_PASSWORD/g" /etc/cantaloupe.properties
echo "Starting Cantaloupe"
java -XX:+UnlockExperimentalVMOptions  -Dcom.sun.management.jmxremote -Dcantaloupe.config=/etc/cantaloupe.properties -Daws.accessKeyId=$AWS_ACCESS_KEY_ID -Daws.secretKey=$AWS_SECRET_ACCESS_KEY -Xmx1g -jar /usr/local/cantaloupe/cantaloupe-$CANTALOUPE_VERSION.war 
