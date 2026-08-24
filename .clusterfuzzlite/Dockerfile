# Use 17
FROM gcr.io/oss-fuzz-base/base-builder-jvm

# Install Java 21 OpenJDK and Maven
RUN apt-get update && apt-get install -y openjdk-21-jdk openjdk-21-jre maven

# Point JAVA_HOME to Java 21 so Jazzer and Maven pick it up automatically
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

COPY . $SRC/jazzer-poc
WORKDIR $SRC/jazzer-poc
COPY .clusterfuzzlite/build.sh $SRC/

