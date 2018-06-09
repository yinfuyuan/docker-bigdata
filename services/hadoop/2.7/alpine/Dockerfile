FROM openjdk:8-jre-alpine

MAINTAINER yinfuyuan <yinfuyuan@gmail.com>

ENV HADOOP_MAJOR=2.7 \
    HADOOP_VERSION=2.7.6 \
    HADOOP_HOME=/usr/local/hadoop

ENV HADOOP_DOWNLOAD_URL="http://www.us.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
    HADOOP_ASC_URL="http://www.us.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.asc" \
    HADOOP_KEYS_URL="http://www.us.apache.org/dist/hadoop/common/KEYS" \
    PATH=${PATH}:${HADOOP_HOME}/bin

RUN set -ex; \
    \
    apk add --no-cache \
        bash \
        openssh; \
    \
    ssh-keygen -A; \
    ssh-keygen -t rsa -f ~/.ssh/id_rsa; \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys; \
    echo "StrictHostKeyChecking no" >> ~/.ssh/config; \
    \
    wget -O "hadoop-${HADOOP_VERSION}.tar.gz" "${HADOOP_DOWNLOAD_URL}"; \
    wget -O "hadoop-${HADOOP_VERSION}.tar.gz.asc" "${HADOOP_ASC_URL}"; \
    wget -O "KEYS" "${HADOOP_KEYS_URL}"; \
    \
    apk add --no-cache --virtual .build-deps gnupg; \
    gpg --import KEYS; \
    gpg --verify hadoop-${HADOOP_VERSION}.tar.gz.asc hadoop-${HADOOP_VERSION}.tar.gz; \
    \
    mkdir -p "${HADOOP_HOME}"; \
    tar -xzf "hadoop-${HADOOP_VERSION}.tar.gz" -C "${HADOOP_HOME}" --strip-components=1; \
    \
    ln -s ${HADOOP_HOME}/etc/hadoop /etc/hadoop; \
    \
    rm -rf \
        KEYS \
        hadoop-${HADOOP_VERSION}.tar.gz \
        hadoop-${HADOOP_VERSION}.tar.gz.asc; \
    apk del .build-deps

COPY etc/hadoop/ ${HADOOP_HOME}/etc/hadoop/

COPY docker-entrypoint.sh /usr/local/bin/

#ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9000

CMD ["/usr/sbin/sshd", "-D"]