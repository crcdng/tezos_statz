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
