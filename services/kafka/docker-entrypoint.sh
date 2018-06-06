#!/bin/bash

set -e

# Allow the container to be started with `--user`
if [[ "$1" = 'kafka-server-start.sh' && "$(id -u)" = '0' ]]; then
    chown -R "$KAFKA_USER" "$KAFKA_DATA_DIR" "$KAFKA_DATA_LOG_DIR"
    exec su-exec "$KAFKA_USER" "$0" "$@"
fi

# Generate the config only if it doesn't exist
if [[ -f "$KAFKA_CONF_DIR/server.properties" ]]; then
    CONFIG="$KAFKA_CONF_DIR/server.properties"
    sed -i s/"broker.id=0"/"broker.id=$BROKER_ID"/g "$CONFIG"
    sed -i s/"#listeners=PLAINTEXT:\/\/:9092"/"listeners=PLAINTEXT:\/\/$LISTENERS"/g "$CONFIG"
    sed -i s/"#advertised.listeners=PLAINTEXT:\/\/your.host.name:9092"/"advertised.listeners=PLAINTEXT:\/\/$ADVERTISED_LISTENERS"/g "$CONFIG"
    sed -i s/"zookeeper.connect=localhost\:2181"/"zookeeper.connect=$ZOOKEEPER_CONNECT"/g "$CONFIG"
fi

exec "$@"
