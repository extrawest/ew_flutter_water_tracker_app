///This extension method allows us to convert only date(without time)
///to milliseconds and return it as a String
///E. g.
///Input "2022-05-23 12:39:51.928" as DateTime
///Output "1653253200000" as String
extension DateTimeToMillisecondsString on DateTime {
  String toMillisecondsString() {
    final DateTime date = this;
    return DateTime.parse(date.toString().split(' ')[0])
        .millisecondsSinceEpoch
        .toString();
  }
}
