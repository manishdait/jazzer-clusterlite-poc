# Step 1: Build the project

# Build the project .jar as usual, e.g. using Maven.
mvn package
mvn dependency:copy-dependencies -DincludeScope=test -DoutputDirectory=target/dependency
# In this example, the project is built with Maven, which typically includes the
# project version into the name of the packaged .jar file. The version can be
# obtained as follows:
CURRENT_VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate \
-Dexpression=project.version -q -DforceStdout)
# Copy the project .jar into $OUT under a fixed name.
cp "target/jazzer-poc-$CURRENT_VERSION.jar" $OUT/jazzer-poc.jar

# Specify the projects .jar file(s), separated by spaces if there are multiple.
PROJECT_JARS="jazzer-poc.jar"

# Step 2: Build the fuzzers (should not require any changes)

# The classpath at build-time includes the project jars in $OUT as well as the
# Jazzer API.

export JAZZER_API_PATH=$(find target/dependency -name "*.jar" | paste -sd ":" -)

BUILD_CLASSPATH=$(echo $PROJECT_JARS | xargs printf -- "$OUT/%s:"):$JAZZER_API_PATH

RUNTIME_CLASSPATH="\$this_dir:\$this_dir/jazzer-poc.jar"

for fuzzer in $(find $SRC -name '*Fuzzer.java' -o -name "*FuzzTest.java"); do
  fuzzer_basename=$(basename -s .java $fuzzer)

  # Extract the package statement if present
  package_name=$(grep -E '^\s*package\s+' "$fuzzer" | sed -E 's/^\s*package\s+([^;]+);.*/\1/' | tr -d ' \r\n')

  if [ -n "$package_name" ]; then
    target_class="${package_name}.${fuzzer_basename}"
  else
    target_class="${fuzzer_basename}"
  fi

  # Compile directly into $OUT so directory structure matches the package name
  javac -d $OUT -cp $BUILD_CLASSPATH $fuzzer

  # Create an execution wrapper that executes Jazzer with the correct parameters
  echo "#!/bin/bash
# LLVMFuzzerTestOneInput for fuzzer detection.
this_dir=\$(dirname \"\$0\")
if [[ \"\$@\" =~ (^| )-runs=[0-9]+($| ) ]]; then
  mem_settings='-Xmx1900m:-Xss900k'
else
  mem_settings='-Xmx2048m:-Xss1024k'
fi
LD_LIBRARY_PATH=\"$JVM_LD_LIBRARY_PATH\":\$this_dir \
\$this_dir/jazzer_driver --agent_path=\$this_dir/jazzer_agent_deploy.jar \
--cp=$RUNTIME_CLASSPATH \
--target_class=$target_class \
--jvm_args=\"\$mem_settings:-Djava.awt.headless=true\" \
\$@" > $OUT/$fuzzer_basename

  chmod +x $OUT/$fuzzer_basename
done
