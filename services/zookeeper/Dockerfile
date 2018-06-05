FROM yinfuyuan/java:8u171-jdk-centos7

MAINTAINER yinfuyuan <yinfuyuan@gmail.com>

ENV ZOOKEEPER_MAJOR=3.4 \
    ZOOKEEPER_VERSION=3.4.12 \
    ZOOKEEPER_HOME=/usr/local/zookeeper-3.4.12

ENV ZOOKEEPER_DOWNLOAD_URL="https://www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz" \
    ZOOKEEPER_DOWNLOAD_SHA="https://www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz.asc" \
    PATH=${PATH}:${ZOOKEEPER_HOME}/bin

RUN set -x; \
    \
    wget -O zookeeper-${ZOOKEEPER_VERSION}.tar.gz "${ZOOKEEPER_DOWNLOAD_URL}"; \
    \
    mkdir -p /usr/local/zookeeper-${ZOOKEEPER_VERSION} \
        /usr/local/zookeeper-${ZOOKEEPER_VERSION}/data \
        /usr/local/zookeeper-${ZOOKEEPER_VERSION}/logs; \
    tar -xzf zookeeper-${ZOOKEEPER_VERSION}.tar.gz -C /usr/local/zookeeper-${ZOOKEEPER_VERSION} --strip-components=1; \
    \
    rm -rf zookeeper-${ZOOKEEPER_VERSION}.tar.gz

COPY conf/zoo.cfg /usr/local/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo.cfg

CMD ["zkServer.sh", "start-foreground"]

