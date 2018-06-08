#!/bin/bash

set -e

# Change the config only if it exist
if [[ -f "$KAFKA_CONF_DIR/server.properties" ]]; then
    CONFIG="$KAFKA_CONF_DIR/server.properties"
    sed -i s/"broker.id=0"/"broker.id=${BROKER_ID:-0}"/g "$CONFIG"
    sed -i s/"#listeners=PLAINTEXT:\/\/:9092"/"listeners=PLAINTEXT:\/\/${LISTENERS:-127.0.0.1:9092}"/g "$CONFIG"
    sed -i s/"#advertised.listeners=PLAINTEXT:\/\/your.host.name:9092"/"advertised.listeners=PLAINTEXT:\/\/${ADVERTISED_LISTENERS:-127.0.0.1:9092}"/g "$CONFIG"
    sed -i s/"zookeeper.connect=localhost:2181"/"zookeeper.connect=${ZOOKEEPER_CONNECT:-127.0.0.1:2181}"/g "$CONFIG"
fi

exec kafka-server-start.sh $KAFKA_CONF_DIR/server.properties
