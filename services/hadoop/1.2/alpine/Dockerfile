FROM openjdk:8u151-alpine

MAINTAINER yinfuyuan <yinfuyuan@gmail.com>

ENV HADOOP_MAJOR=1.2 \
    HADOOP_VERSION=1.2.1 \
    HADOOP_PREFIX=/usr/local/hadoop

ENV PATH=$PATH:${HADOOP_PREFIX}/bin \
    HADOOP_DOWNLOAD_URL="http://www-us.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
    HADOOP_GPG_KEY_SERVER="pgpkeys.mit.edu" \
    HADOOP_GPG_RECV_KEY="4169AA27ECB31663"

RUN set -x; \
    \
    apk add --no-cache \
        bash \
        openssh; \
    \
    ssh-keygen -A; \
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa; \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys; \
    chmod 0600 ~/.ssh/authorized_keys; \
    \
    wget -O hadoop-${HADOOP_VERSION}.tar.gz "${HADOOP_DOWNLOAD_URL}"; \
    wget -O hadoop-${HADOOP_VERSION}.tar.gz.asc "${HADOOP_DOWNLOAD_URL}.asc"; \
    \
    apk add --no-cache --virtual .build-deps gnupg; \
    gpg --keyserver ${HADOOP_GPG_KEY_SERVER} --recv-key ${HADOOP_GPG_RECV_KEY}; \
    gpg --verify hadoop-${HADOOP_VERSION}.tar.gz.asc hadoop-${HADOOP_VERSION}.tar.gz; \
    \
    mkdir -p /usr/local/hadoop; \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/local/hadoop --strip-components=1; \
    \
    ln -s ${HADOOP_PREFIX}/conf /etc/hadoop; \
    \
    rm -rf \
        hadoop-${HADOOP_VERSION}.tar.gz \
        hadoop-${HADOOP_VERSION}.tar.gz.asc; \
    apk del .build-deps

COPY conf /usr/local/hadoop/conf

COPY docker-entrypoint.sh /usr/local/bin/

COPY ssh_config /root/.ssh/config

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9000

CMD ["hadoop-server"]