
FROM maven:3.6.3-jdk-8
#FROM openjdk:8u121-jdk

LABEL maintainer-twitter="@coheigea"
LABEL version=2.1.0

ARG RANGER_VERSION=2.1.0

ADD https://jdbc.postgresql.org/download/postgresql-42.2.1.jar /opt

ADD http://mirrors.whoishostingthis.com/apache/ranger/${RANGER_VERSION}/apache-ranger-${RANGER_VERSION}.tar.gz /opt

COPY ranger-entrypoint.sh /opt

WORKDIR /opt

RUN apt-get -q update && apt-get install -y -q python gcc \
 && tar zxvf apache-ranger-${RANGER_VERSION}.tar.gz \
 && cd apache-ranger-${RANGER_VERSION} \
 && mvn clean compile package install -DskipTests \
 && cp target/ranger-${RANGER_VERSION}-admin.tar.gz /opt \
 && cd /opt \
 && tar zxvf ranger-${RANGER_VERSION}-admin.tar.gz \
 && chmod +x /opt/ranger-entrypoint.sh

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV RANGER_HOME=/opt/ranger-${RANGER_VERSION}-admin

COPY install.properties ${RANGER_HOME}

EXPOSE 6080

ENTRYPOINT ["/opt/ranger-entrypoint.sh"]
