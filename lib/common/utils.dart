import 'constants.dart' as constants;

String padLeft(String s) => s.length == 1 ? "0" + s : s;

String formatDateTime(DateTime dateTime) {
  String y = dateTime.year.toString();
  String m = padLeft(dateTime.month.toString());
  String d = padLeft(dateTime.day.toString());
  String h = padLeft(dateTime.hour.toString());
  String min = padLeft(dateTime.minute.toString());
  String sec = padLeft(dateTime.second.toString());
  return "$y-$m-$d $h:$min:$sec";
}

bool isValidAddress(String? str) {
  return (str != null &&
      str.length == constants.addressStringLength &&
      RegExp(r'^[A-Za-z0-9]+$').hasMatch(str) &&
      (str.startsWith("tz1") ||
          str.startsWith("tz2") ||
          str.startsWith("tz3")));
}
