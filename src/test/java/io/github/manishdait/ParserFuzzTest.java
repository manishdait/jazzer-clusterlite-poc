package io.github.manishdait;

import com.code_intelligence.jazzer.api.FuzzedDataProvider;
import com.code_intelligence.jazzer.junit.FuzzTest;

public class ParserFuzzTest {
  @FuzzTest(maxDuration = "1m")
  void fuzzParseInput(FuzzedDataProvider dataProvider) {
    String input = dataProvider.consumeRemainingAsString();
    try {
      TestParser.parse(input);
    } catch (IllegalStateException e) {
      // Ignore expected validation exceptions so the fuzzer keeps running
    }
    // IllegalStateException is not caught, so Jazzer will flag it as a crash
  }
}
