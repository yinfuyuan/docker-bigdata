#!/bin/bash

set -e

/etc/init.d/ssh start

hadoop namenode -format

start-all.sh

if [ "${1#-}" != "$1" ]; then
	set -- hadoop "$@"
fi

if [ "$1" = 'hadoop-server' ]; then
    kill $(pidof sshd)
	/etc/init.d/ssh start -d
fi

exec "$@"