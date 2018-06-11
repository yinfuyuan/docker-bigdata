#!/bin/bash

set -e

if [ "$1" = 'start-all.sh' ]; then
    /etc/init.d/ssh start
    hdfs namenode -format
    start-dfs.sh
    start-yarn.sh
    tail -f /dev/null
fi

exec "$@"