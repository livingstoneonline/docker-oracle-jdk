FROM livingstoneonline/base:xenial
MAINTAINER Nigel Banks <nigel.g.banks@gmail.com>

LABEL "License"="GPLv3" \
      "Version"="0.0.1"

ARG JAVA_VERSION_MAJOR=8
ARG JAVA_VERSION_UPDATE=121
ARG JAVA_VERSION_BUILD=13
ARG JAVA_SIGNATURE=e9e7ea248e2c4826b92b3f075a80e441
ARG OPENSSL_VERSION=1.0.2j

ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION_MAJOR}-oracle

RUN apt-install \
      gcc \
      libc6-dev \
      libssl-dev \
      make \
      apt-utils \
    && \
    curl --silent --location --retry 3 --cacert /etc/ssl/certs/GeoTrust_Global_CA.pem \
	       --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
	       http://download.oracle.com/otn-pub/java/jdk/"${JAVA_VERSION_MAJOR}"u"${JAVA_VERSION_UPDATE}"-b"${JAVA_VERSION_BUILD}"/"${JAVA_SIGNATURE}"/jre-"${JAVA_VERSION_MAJOR}"u"${JAVA_VERSION_UPDATE}"-linux-x64.tar.gz \
	       | tar xz -C /tmp && \
    mkdir -p /usr/lib/jvm && \
    mv /tmp/jre1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_UPDATE} ${JAVA_HOME} && \
	  curl --silent --location --retry 3 --cacert /etc/ssl/certs/GlobalSign_Root_CA.pem \
         https://www.openssl.org/source/openssl-"${OPENSSL_VERSION}".tar.gz \
         | tar xz -C /tmp && \
    cd /tmp/openssl-"${OPENSSL_VERSION}" && \
    ./config --prefix=/usr && \
    make clean && make && make install && \
    apt-remove \
      gcc \
      libc6-dev \
      libssl-dev \
      make \
    && \
    cleanup

RUN update-alternatives --install "/usr/bin/java" "java" "${JAVA_HOME}/bin/java" 1 && \
	  update-alternatives --install "/usr/bin/javaws" "javaws" "${JAVA_HOME}/bin/javaws" 1 && \
	  update-alternatives --set java "${JAVA_HOME}/bin/java" && \
	  update-alternatives --set javaws "${JAVA_HOME}/bin/javaws"

