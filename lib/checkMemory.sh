#!/bin/bash

LIB_DIR=/usr/local/jmx_monitor
CANTALOUPE_PID=`jps |grep Cantaloupe|sed 's/ .*$//g'`
JAVA_HOME=/usr/lib/jvm/java-8-oracle

date
java -classpath $JAVA_HOME/lib/tools.jar:$LIB_DIR/jmx-monitor-1.0.jar com.gdmrdigital.jmx.MonitorMemory $CANTALOUPE_PID

# killing the pid $CANTALOUPE_PID will stop the docker
