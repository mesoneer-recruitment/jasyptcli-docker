ARG JASYPT_VERSION=1.9.3
ARG JASYPT_DIST_URL=https://github.com/jasypt/jasypt/releases/download/jasypt-${JASYPT_VERSION}/jasypt-${JASYPT_VERSION}-dist.zip
ARG UID=3000
ARG JAVA_BASE_IMAGE=adoptopenjdk:8u262-b10-jre-hotspot-bionic

FROM adoptopenjdk:8u262-b10-jre-hotspot-bionic as build

ARG JASYPT_DIST_URL

RUN apt-get update \
      && apt-get install wget unzip \
      && wget ${JASYPT_DIST_URL} -O /tmp/jasypt-${JASYPT_VERSION}.zip \
      && unzip /tmp/jasypt-${JASYPT_VERSION}.zip -d /opt/

FROM ${JAVA_BASE_IMAGE} as intermediate

RUN curl -o /tmp/icu4j-67.1.jar https://repo1.maven.org/maven2/com/ibm/icu/icu4j/67.1/icu4j-67.1.jar

FROM adoptopenjdk:8u262-b10-jre-hotspot-bionic as final

ARG JASYPT_VERSION
ARG UID

RUN groupadd -g ${UID} jasypt \
  && useradd -m -u ${UID} -g ${UID} -s /bin/bash jasypt

COPY --chown=jasypt:jasypt --from=build /opt/jasypt-${JASYPT_VERSION}/ /opt/jasypt

RUN chmod u+x /opt/jasypt/bin/*.sh

COPY --chown=jasypt:jasypt docker-entrypoint.sh /opt/
ENTRYPOINT [ "/opt/docker-entrypoint.sh" ]

WORKDIR /opt/jasypt
USER jasypt

# Fix jasypt-1.9.3 cannot work with JDK with build version > 255.
# This is fixed in jasypt-1.9.4-SNAPSHOT.
COPY --chown=jasypt:jasypt --from=intermediate /tmp/icu4j-67.1.jar /opt/jasypt/lib/icu4j-3.4.4.jar
