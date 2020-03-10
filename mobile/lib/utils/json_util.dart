import 'package:intl/intl.dart';

class JsonUtil {
  static String capitalizeFirst(Map<String, dynamic> json, String key) {
    String val = json[key].toString();
    return val[0].toUpperCase() + val.substring(1);
  }

  static String prettyDate(String datetime) {
    return DateFormat('dd.MM.yyyy EE HH:mm:ss').format(DateTime.parse(datetime));
  }
}
