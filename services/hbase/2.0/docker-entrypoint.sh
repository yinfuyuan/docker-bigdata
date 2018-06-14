#!/bin/bash

set -e

if [[ -n "$CLUSTER" ]]; then
    if [[ -n "$HDFS_FS_DEFAULTFS" ]]; then
        sed -i s/"hdfs:\/\/localhost:9000"/"hdfs:\/\/$HDFS_FS_DEFAULTFS"/g "$HADOOP_CONF_DIR/core-site.xml"
    fi
    if [[ -n "$HDFS_SLAVES" ]]; then
        echo -e "${HDFS_SLAVES/,/\\n}" > "$HADOOP_CONF_DIR/slaves"
    fi
    if [[ -n "$HDFS_DFS_REPLICATION" ]]; then
        sed -i s/"<value>1<\/value>"/"<value>$HDFS_DFS_REPLICATION<\/value>"/g "$HADOOP_CONF_DIR/hdfs-site.xml"
    fi
    if [[ -n "$HBASE_ROOTDIR" ]]; then
        sed -i s/"hdfs:\/\/localhost:8020\/hbase"/"hdfs:\/\/${HBASE_ROOTDIR/\//\\/}"/g "$HBASE_HOME/conf/hbase-site.xml"
    fi
    if [[ -n "$HBASE_CLUSTER_DISTRIBUTED" ]]; then
        sed -i s/"<value>false<\/value>"/"<value>$HBASE_CLUSTER_DISTRIBUTED<\/value>"/g "$HBASE_HOME/conf/hbase-site.xml"
    fi
    if [[ -n "$HBASE_ZOOKEEPER_QUORUM" ]]; then
        sed -i s/"<value>localhost<\/value>"/"<value>$HBASE_ZOOKEEPER_QUORUM<\/value>"/g "$HBASE_HOME/conf/hbase-site.xml"
    fi
    if [[ -n "$HBASE_REGION_SERVERS" ]]; then
        echo -e "${HBASE_REGION_SERVERS/,/\\n}" > "$HBASE_HOME/conf/regionservers"
    fi
    if [[ -n "$HBASE_BACKUP_MASTER" ]]; then
        echo -e "${HBASE_BACKUP_MASTER/,/\\n}" > "$HBASE_HOME/conf/backup-masters"
    fi
    echo "export HBASE_MANAGES_ZK=false" >> "$HBASE_HOME/conf/hbase-env.sh"
fi

if [ "$1" = 'start-hbase.sh' ]; then
    /etc/init.d/ssh start
    hdfs namenode -format
    start-dfs.sh
    if [[ -z "$CLUSTER" || -n "$HBASE_MASTER" ]]; then
        start-hbase.sh
    fi
    tail -f /dev/null
fi

exec "$@"