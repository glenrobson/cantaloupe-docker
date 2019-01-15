#!/bin/bash

echo "Starting cron"
sudo cron

echo "Starting Cantaloupe"
java -XX:+UnlockExperimentalVMOptions  -Dcom.sun.management.jmxremote -Dcantaloupe.config=/etc/cantaloupe.properties -Daws.accessKeyId=$AWS_ACCESS_KEY_ID -Daws.secretKey=$AWS_SECRET_ACCESS_KEY -Xmx1g -jar /usr/local/cantaloupe/Cantaloupe-$CANTALOUPE_VERSION.war 
