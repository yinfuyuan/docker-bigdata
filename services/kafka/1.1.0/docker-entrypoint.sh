#!/bin/bash

set -e

if [ "$1" = 'kafka-server-start.sh' ]; then
    kafka-server-start.sh /etc/kafka/server.properties
fi

exec "$@"
