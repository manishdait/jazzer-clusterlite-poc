# Use 17
FROM gcr.io/oss-fuzz-base/base-builder-jvm

RUN apt-get update && apt-get install -y maven

COPY . $SRC/jazzer-poc
WORKDIR $SRC/jazzer-poc
COPY .clusterfuzzlite/build.sh $SRC/

