# jazzer-clusterlite-poc 

A Jazzer and ClusterFuzzLite Java (PoC) demonstrating fuzz testing for Java applications using Jazzer, JUnit, Maven, and ClusterFuzzLite.

## Overview

This repository demonstrates how to discover hidden edge cases, unhandled exceptions, and security vulnerabilities in Java parsers before they reach production.

- Fuzzing Engine: Jazzer
- Runtime Target: Java 17
- Build System: Apache Maven 
- Continuous Integration: GitHub Actions + ClusterFuzzLite



## Fuzz Target Execution Patterns
Patterns to execute standalone fuzzer and fuzzer test.

### Pattern 1: Standard Standalone Fuzz Target

Used by pure Jazzer CLI invocations and continuous fuzzing infrastructure:
Java
```java
package io.github.manishdait;

import com.code_intelligence.jazzer.api.FuzzedDataProvider;

public class ParserStandaloneFuzzer {

    // REQUIRED: Must be public static void fuzzerTestOneInput
    public static void fuzzerTestOneInput(FuzzedDataProvider data) {
        String input = data.consumeRemainingAsString();
        TestParser.parseInput(input);
    }
}
```


> [!WARNING]
> **Base Image Limitations & Requirements:**
> - **Java Version:** The default `gcr.io/oss-fuzz-base/base-builder-jvm` base image only supports up to **Java 17**.
> - **Target Signature:** Native ClusterFuzzLite standalone runs require the exact target entry point method signature: `public static void fuzzerTestOneInput(FuzzedDataProvider data)`.


### Pattern 2: JUnit 5 @FuzzTest Target

Integrated directly into standard Maven mvn test executions:
```java
package io.github.manishdait;

import com.code_intelligence.jazzer.api.FuzzedDataProvider;
import com.code_intelligence.jazzer.junit.FuzzTest;

public class ParserFuzzTest {

    @FuzzTest(maxDuration = "1m")
    void fuzzParseInput(FuzzedDataProvider data) {
        String input = data.consumeRemainingAsString();
        TestParser.parseInput(input);
    }
}
```

> [!WARNING]
> This pattern don't run well in the clusterfuzzlite CI (Need to investigate more)

### Quick Start Commands
```bash
# 1. Standard build and regression test pass
mvn test

# 2. Run active fuzzing locally via Maven
JAZZER_FUZZ=1 mvn test -Dtest=ParserFuzzTest
JAZZER_FUZZ=1 mvn test
```

## Useful References:
- [Integrating a Java/JVM project](https://google.github.io/oss-fuzz/getting-started/new-project-guide/jvm-lang)
- [ClusterFuzzLite GitHub Actions](https://google.github.io/clusterfuzzlite/running-clusterfuzzlite/github-actions/)
- [Hiero Python SDK CI](https://github.com/hiero-ledger/hiero-sdk-python/blob/main/.github/workflows/clusterfuzzlite.yml)
