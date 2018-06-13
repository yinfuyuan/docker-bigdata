#!/bin/bash

set -e

if [[ -n "$CLUSTER" ]]; then
    if [[ -n "$HDFS_FS_DEFAULTFS" ]]; then
        sed -i s/"hdfs:\/\/localhost:9000"/"hdfs:\/\/$HDFS_FS_DEFAULTFS"/g "$HADOOP_CONF_DIR/core-site.xml"
    fi
    if [[ -n "$HDFS_SLAVES" ]]; then
        echo $HDFS_SLAVES > "$HADOOP_CONF_DIR/slaves"
        sed -i s/","/"\n"/g "$HADOOP_CONF_DIR/slaves"
    fi
    if [[ -n "$HDFS_DFS_REPLICATION" ]]; then
        sed -i s/"<value>1<\/value>"/"<value>$HDFS_DFS_REPLICATION<\/value>"/g "$HADOOP_CONF_DIR/hdfs-site.xml"
    fi
    if [[ -n "$HBASE_ROOTDIR" ]]; then
        if [[ -n "$HBASE_ROOTDIR_HDFS" ]]; then
            sed -i s/"hdfs:\/\/localhost:8020\/hbase"/"hdfs:\/\/$HBASE_ROOTDIR_HDFS\/$HBASE_ROOTDIR"/g "$HBASE_HOME/conf/hbase-site.xml"
        else
            sed -i s/"hdfs:\/\/localhost:8020\/hbase"/"$HBASE_ROOTDIR"/g "$HBASE_HOME/conf/hbase-site.xml"
        fi
    fi
    if [[ -n "$HBASE_CLUSTER_DISTRIBUTED" ]]; then
        sed -i s/"<value>false<\/value>"/"<value>$HBASE_CLUSTER_DISTRIBUTED<\/value>"/g "$HBASE_HOME/conf/hbase-site.xml"
    fi
    if [[ -n "$HBASE_ZOOKEEPER_QUORUM" ]]; then
        sed -i s/"<value>localhost<\/value>"/"<value>$HBASE_ZOOKEEPER_QUORUM<\/value>"/g "$HBASE_HOME/conf/hbase-site.xml"
    fi
    if [[ -n "$HBASE_REGIONSERVERS" ]]; then
        echo $HBASE_REGIONSERVERS > "$HBASE_HOME/conf/regionservers"
        sed -i s/","/"\n"/g "$HBASE_HOME/conf/regionservers"
    fi
    echo "export HBASE_MANAGES_ZK=false" >> "$HBASE_HOME/conf/hbase-env.sh"
fi

if [ "$1" = 'start-hbase.sh' ]; then
    /etc/init.d/ssh start
    hdfs namenode -format
    start-dfs.sh
    start-hbase.sh
    tail -f /dev/null
fi

exec "$@"