// a value such as 1 is parsed as an int by the Dart JSON parser
// the entities require double? / double values

// this extension parses JSON integer / float number / missing value into double?
// and JSON integer / float number into double
// recommended to import with ... as extensions;

extension NumberParsing on num? {
  double? toDoubleOrNull() {
    if (this == null) {
      return null;
    }
    return this!.toDouble();
  }

  double toDouble() {
    return this!.toDouble();
  }
}
