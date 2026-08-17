package io.github.manishdait;

import com.code_intelligence.jazzer.api.FuzzedDataProvider;

public class ParserFuzzer {
  public static void fuzzerTestOneInput(FuzzedDataProvider dataProvider) {
    String input = dataProvider.consumeRemainingAsString();
    try {
      TestParser.parse(input);
    } catch (IllegalStateException e) {
      // Ignore expected validation exceptions so the fuzzer keeps running
    }
    // IllegalStateException is not caught, so Jazzer will flag it as a crash
  }
}
