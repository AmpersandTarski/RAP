# Gatling is a load testing tool.
# Documentation: https://gatling.io/docs/3.2/
# Cheat sheet: https://gatling.io/docs/3.2/cheat-sheet/

FROM container-registry.oracle.com/java/openjdk:17.0.1
RUN dnf -y update

# working directory for gatling
WORKDIR /opt

# gating version
ENV GATLING_VERSION 3.7.2

# create directory for gatling install
RUN mkdir -p gatling

RUN dnf install -y wget unzip

RUN mkdir -p /tmp/downloads

RUN wget -q -O /tmp/downloads/gatling-$GATLING_VERSION.zip \
  https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/$GATLING_VERSION/gatling-charts-highcharts-bundle-$GATLING_VERSION-bundle.zip

# install gatling
# RUN apk add --update wget bash libc6-compat && \
RUN mkdir -p /tmp/archive && cd /tmp/archive && \
  unzip /tmp/downloads/gatling-$GATLING_VERSION.zip && \
  mv /tmp/archive/gatling-charts-highcharts-bundle-$GATLING_VERSION/* /opt/gatling/ && \
  rm -rf /tmp/*

# change context to gatling directory
WORKDIR  /opt/gatling

ADD ./user-files/simulations/*.scala /opt/gatling/user-files/simulations

# set directories below to be mountable from host
VOLUME ["/opt/gatling/conf", "/opt/gatling/results", "/opt/gatling/user-files"]

# set environment variables
ENV PATH /opt/gatling/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$JAVA_HOME/bin
ENV GATLING_HOME /opt/gatling

ENTRYPOINT ["gatling.sh"]