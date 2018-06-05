FROM centos:7

MAINTAINER yinfuyuan <yinfuyuan@gmail.com>

ENV JAVA_HOME=/usr/local/jdk1.8.0_171

ENV JAVA_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz?AuthParam=1528163994_2ad6fb0a96ba32ebe591fed1b6c589c0" \
    JAVA_SHA="b6dd2837efaaec4109b36cfbb94a774db100029f98b0d78be68c27bec0275982" \
    PATH=${PATH}:${JAVA_HOME}/bin

RUN set -x; \
    \
    yum install -y wget;\
    \
    wget -O jdk-8u171-linux-x64.tar.gz "${JAVA_DOWNLOAD_URL}"; \
    echo "${JAVA_SHA} jdk-8u171-linux-x64.tar.gz" | sha256sum -c -; \
    \
    mkdir -p /usr/local/jdk1.8.0_171; \
    tar -xzf jdk-8u171-linux-x64.tar.gz -C /usr/local/jdk1.8.0_171 --strip-components=1; \
    \
    echo "export JAVA_HOME=/usr/local/jdk1.8.0_171" >> /etc/profile; \
    echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile; \
    source /etc/profile; \
    \
    rm -rf jdk-8u171-linux-x64.tar.gz