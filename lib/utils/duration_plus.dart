class DurationPlus {
  static Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  static String stringifyDuration(Duration duration) {
    final hour = duration.inHours;
    final minutes = duration.inMinutes % 60;
    String hr = hour >= 10 ? hour.toString() : "0$hour";
    String mins = minutes >= 10 ? minutes.toString() : "0$minutes";
    return "$hr:$mins";
  }
}