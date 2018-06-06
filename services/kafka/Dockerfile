FROM openjdk:8-jre-alpine

MAINTAINER yinfuyuan <yinfuyuan@gmail.com>

# Install required packages
RUN apk add --no-cache \
    bash \
    su-exec

ENV KAFKA_HOME=/usr/local/kafka \
    KAFKA_USER=kafka

ENV KAFKA_CONF_DIR=${KAFKA_HOME}/config \
    KAFKA_LOGS_DIR=${KAFKA_HOME}/logs \
    PATH=${PATH}:${KAFKA_HOME}/bin

# Add a user and make dirs
RUN set -ex; \
    adduser -D "$KAFKA_USER"

# Download Apache Kafka, untar and clean up
RUN set -ex; \
    \
    wget -O kafka_2.11-1.1.0.tgz "http://mirror.bit.edu.cn/apache/kafka/1.1.0/kafka_2.11-1.1.0.tgz"; \
    \
    mkdir -p "$KAFKA_HOME"; \
    tar -xzf kafka_2.11-1.1.0.tgz -C "$KAFKA_HOME" --strip-components=1; \
    mkdir "$KAFKA_LOGS_DIR"; \
    chown "$KAFKA_USER:$KAFKA_USER" "$KAFKA_HOME"; \
    rm -rf kafka_2.11-1.1.0.tgz;

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["kafka-server-start.sh /usr/local/kafka/config/server.properties"]