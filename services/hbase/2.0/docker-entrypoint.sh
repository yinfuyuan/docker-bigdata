#!/bin/bash

set -e

if [[ -n "$HBASE_CLUSTER" ]]; then

    HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
    if [[ -n "$HDFS_FS_DEFAULTFS" ]]; then
        sed -i "/<name>fs.defaultFS<\/name>/{n;s/<value>.*<\/value>/<value>${HDFS_FS_DEFAULTFS////\\/}<\/value>/g}" "$HADOOP_CONF_DIR/core-site.xml"
    fi
    if [[ -n "$HDFS_SLAVES" ]]; then
        echo -e "${HDFS_SLAVES/,/\\n}" > "$HADOOP_CONF_DIR/slaves"
    fi
    sed -i "/<name>dfs.replication<\/name>/{n;s/<value>.*<\/value>/<value>${HDFS_DFS_REPLICATION:-1}<\/value>/g}" "$HADOOP_CONF_DIR/hdfs-site.xml"
    sed -i "s/<\/configuration>/<property>\n<name>dfs.datanode.max.transfer.threads<\/name>\n<value>4096<\/value>\n<\/property>\n<\/configuration>/g" "$HADOOP_CONF_DIR/hdfs-site.xml"

    HBASE_CONF_DIR=${HBASE_HOME}/conf
    if [[ -n "$HBASE_ROOTDIR" ]]; then
        sed -i "/<name>hbase.rootdir<\/name>/{n;s/<value>.*<\/value>/<value>${HBASE_ROOTDIR////\\/}<\/value>/g}" "$HBASE_CONF_DIR/hbase-site.xml"
    fi
    if [[ -n "$HBASE_REGION_SERVERS" ]]; then
        echo -e "${HBASE_REGION_SERVERS/,/\\n}" > "$HBASE_HOME/conf/regionservers"
    fi
    if [[ -n "$HBASE_BACKUP_MASTER" ]]; then
        echo -e "${HBASE_BACKUP_MASTER/,/\\n}" > "$HBASE_HOME/conf/backup-masters"
    fi
    sed -i "/<name>hbase.cluster.distributed<\/name>/{n;s/<value>.*<\/value>/<value>${HBASE_CLUSTER_DISTRIBUTED:-false}<\/value>/g}" "$HBASE_CONF_DIR/hbase-site.xml"
    sed -i "/<name>hbase.zookeeper.quorum<\/name>/{n;s/<value>.*<\/value>/<value>${HBASE_ZOOKEEPER_QUORUM:-localhost}<\/value>/g}" "$HBASE_CONF_DIR/hbase-site.xml"
    echo "export HBASE_MANAGES_ZK=false" >> "$HBASE_HOME/conf/hbase-env.sh"

fi

if [ "$1" = 'start-hbase.sh' ]; then
    /etc/init.d/ssh start
    gosu hadoop hdfs namenode -format
    if [[ -z "$HBASE_CLUSTER" || -n "$HDFS_MASTER" ]]; then
        gosu hadoop /usr/local/hadoop/sbin/start-dfs.sh
    fi
    if [[ -z "$HBASE_CLUSTER" || -n "$HBASE_MASTER" ]]; then
        gosu hbase /usr/local/hbase/bin/start-hbase.sh
    fi
    gosu hbase tail -f /dev/null
fi

exec "$@"