FROM openjdk:8-jre-alpine

MAINTAINER yinfuyuan <yinfuyuan@gmail.com>

ENV KAFKA_HOME=/usr/local/kafka \
    SCALA_VERSION=2.11 \
    KAFKA_VERSION=1.1.0

ENV KAFKA_DOWNLOAD_URL="http://mirror.bit.edu.cn/apache/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" \
    KAFKA_ASC_URL="http://www.us.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc" \
    KAFKA_KEYS_URL="http://www.us.apache.org/dist/kafka/KEYS" \
    KAFKA_CONF_DIR=${KAFKA_HOME}/config \
    PATH=${PATH}:${KAFKA_HOME}/bin

RUN set -ex; \
    \
    apk add --no-cache bash; \
    \
    wget -O kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz "${KAFKA_DOWNLOAD_URL}"; \
    wget -O kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc "${KAFKA_ASC_URL}"; \
    wget -O KEYS "${KAFKA_KEYS_URL}"; \
    \
    apk add --no-cache --virtual .build-deps gnupg; \
    gpg --import KEYS; \
    gpg --verify kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz; \
    \
    mkdir -p "$KAFKA_HOME"; \
    tar -xzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C "$KAFKA_HOME" --strip-components=1; \
    \
    rm -rf \
        KEYS \
        kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
        kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc; \
    apk del .build-deps

COPY ./config/server.properties $KAFKA_CONF_DIR/server.properties

COPY ./docker-entrypoint.sh /

CMD ["/docker-entrypoint.sh"]