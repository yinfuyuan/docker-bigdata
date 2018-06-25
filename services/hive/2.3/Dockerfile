FROM yinfuyuan/hadoop:2.7.6

MAINTAINER yinfuyuan <yinfuyuan@gmail.com>

RUN useradd -m -r -g apache hive

ENV HIVE_VERSION=2.3.3 \
    HIVE_HOME=/usr/local/hive

ENV HIVE_DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/apache/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz" \
    HIVE_ASC_URL="http://apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz.asc" \
    HIVE_KEYS_URL="http://apache.org/dist/hive/KEYS" \
    PATH=${PATH}:${HIVE_HOME}/bin

RUN set -ex; \
    \
    gosu hive ssh-keygen -t rsa -f /home/hive/.ssh/id_rsa; \
    gosu hive cat /home/hive/.ssh/id_rsa.pub >> /home/hive/.ssh/authorized_keys; \
    gosu hive echo "StrictHostKeyChecking no" >> /home/hive/.ssh/config; \
    \
    wget -O "hive-${HIVE_VERSION}-bin.tar.gz" "${HIVE_DOWNLOAD_URL}"; \
    wget -O "hive-${HIVE_VERSION}-bin.tar.gz.asc" "${HIVE_ASC_URL}"; \
    wget -O "KEYS" "${HIVE_KEYS_URL}"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends gnupg; \
    gpg --import KEYS; \
    gpg --verify "hive-${HIVE_VERSION}-bin.tar.gz.asc" "hive-${HIVE_VERSION}-bin.tar.gz"; \
    \
    mkdir -p "${HIVE_HOME}"; \
    tar -xzf "hive-${HIVE_VERSION}-bin.tar.gz" -C "${HIVE_HOME}" --strip-components=1; \
    \
    ln -s ${HIVE_HOME}/conf /etc/hive; \
    \
    mkdir /hive && chown -R hive:apache /hive; \
    \
    rm -rf \
        KEYS \
        hive-${HIVE_VERSION}-bin.tar.gz \
        hive-${HIVE_VERSION}-bin.tar.gz.asc \
        ${HIVE_HOME}/docs \
        /var/lib/apt/lists/*; \
    apt-get purge -y --auto-remove gnupg

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]