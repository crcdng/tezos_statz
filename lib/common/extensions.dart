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

extension DateTimeFormatting on DateTime {
  String formatDateTime() {
    String padLeft(String s) => s.length == 1 ? "0" + s : s;

    String y = this.year.toString();
    String m = padLeft(this.month.toString());
    String d = padLeft(this.day.toString());
    String h = padLeft(this.hour.toString());
    String min = padLeft(this.minute.toString());
    String sec = padLeft(this.second.toString());
    return "$y-$m-$d $h:$min:$sec";
  }
}
