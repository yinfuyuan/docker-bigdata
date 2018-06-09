#!/bin/bash

set -e

/usr/sbin/sshd

hadoop namenode -format

start-all.sh

if [ "${1#-}" != "$1" ]; then
	set -- hadoop "$@"
fi

if [ "$1" = 'hadoop-server' ]; then
    kill $(pidof sshd)
	/usr/sbin/sshd -D
fi

exec "$@"