package io.github.manishdait;

public class TestParser {
  public static boolean parse(String input) {
    if (input == null || input.length() < 4) {
      return false;
    }

    if (input.charAt(0) == 'F' && input.charAt(1) == 'U' && input.charAt(2) == 'Z' && input.charAt(3) == 'Z') {
      throw new IllegalStateException("CRASH: Unhandled 'FUZZ' edge case detected!");
    }

    return true;
  }
}
