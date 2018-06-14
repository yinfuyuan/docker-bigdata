#!/bin/bash

set -e

if [[ -n "$HADOOP_CLUSTER" ]]; then
    HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
    if [[ -n "$SLAVES" ]]; then
        echo -e "${SLAVES/,/\\n}" > "$HADOOP_CONF_DIR/slaves"
    fi
    if [[ -n "$FS_DEFAULTFS" ]]; then
        sed -i "/<name>fs.defaultFS<\/name>/{n;s/<value>.*<\/value>/<value>${FS_DEFAULTFS////\\/}<\/value>/g}" "$HADOOP_CONF_DIR/core-site.xml"
    fi
    sed -i "/<name>dfs.replication<\/name>/{n;s/<value>.*<\/value>/<value>${DFS_REPLICATION:-1}<\/value>/g}" "$HADOOP_CONF_DIR/hdfs-site.xml"
    sed -i "/<name>yarn.resourcemanager.hostname<\/name>/{n;s/<value>.*<\/value>/<value>${YARN_RESOURCEMANAGER_HOSTNAME:-0.0.0.0}<\/value>/g}" "$HADOOP_CONF_DIR/yarn-site.xml"
fi

if [ "$1" = 'start-all.sh' ]; then
    /etc/init.d/ssh start
    gosu hadoop /usr/local/hadoop/bin/hdfs namenode -format
    if [[ -z "$HADOOP_CLUSTER" || -n "$HDFS_MASTER" ]]; then
        gosu hadoop /usr/local/hadoop/sbin/start-dfs.sh
    fi
    if [[ -z "$HADOOP_CLUSTER" || -n "$YARN_MASTER" ]]; then
        gosu hadoop /usr/local/hadoop/sbin/start-yarn.sh
    fi
    if [[ -z "$HADOOP_CLUSTER" || -n "$HISTORY_MASTER" ]]; then
        gosu hadoop /usr/local/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver
    fi
    gosu hadoop tail -f /dev/null
fi

exec "$@"