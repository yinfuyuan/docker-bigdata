#!/bin/bash

set -e

if [[ -n "$CLUSTER" ]]; then
    if [[ -n "$FS_DEFAULTFS" ]]; then
        sed -i s/"hdfs:\/\/localhost:9000"/"hdfs:\/\/$FS_DEFAULTFS"/g "$HADOOP_CONF_DIR/core-site.xml"
    fi
    if [[ -n "$SLAVES" ]]; then
        echo $SLAVES > "$HADOOP_CONF_DIR/slaves"
        sed -i s/","/"\n"/g "$HADOOP_CONF_DIR/slaves"
    fi
    if [[ -n "$DFS_REPLICATION" ]]; then
        sed -i s/"<value>1<\/value>"/"<value>$DFS_REPLICATION<\/value>"/g "$HADOOP_CONF_DIR/hdfs-site.xml"
    fi
    if [[ -n "$YARN_RESOURCEMANAGER_HOSTNAME" ]]; then
        sed -i s/"0.0.0.0"/"$YARN_RESOURCEMANAGER_HOSTNAME"/g "$HADOOP_CONF_DIR/yarn-site.xml"
    fi
fi

if [ "$1" = 'start-all.sh' ]; then
    /etc/init.d/ssh start
    hdfs namenode -format
    start-dfs.sh
    start-yarn.sh
    tail -f /dev/null
fi

exec "$@"