# Use 17
FROM gcr.io/oss-fuzz-base/base-builder-jvm

RUN apt-get update && apt-get install -y maven
RUN apt-get update && apt-get install -y openjdk-21-jdk

ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

COPY . $SRC/jazzer-poc
WORKDIR $SRC/jazzer-poc
COPY .clusterfuzzlite/build.sh $SRC/

