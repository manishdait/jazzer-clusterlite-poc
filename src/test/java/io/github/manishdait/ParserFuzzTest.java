package io.github.manishdait;

import com.code_intelligence.jazzer.api.FuzzedDataProvider;
import com.code_intelligence.jazzer.junit.FuzzTest;

public class ParserFuzzTest {
  @FuzzTest(maxDuration = "1m")
  void fuzzParseInput(FuzzedDataProvider dataProvider) {
    String input = dataProvider.consumeRemainingAsString();
    TestParser.parse(input);
  }
}
