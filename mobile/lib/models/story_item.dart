import '../utils/json_util.dart';

class StoryItem {
  final String date;
  final String event;
  final String description;
  bool isExpanded = false;

  StoryItem(this.date, this.event, this.description);

  factory StoryItem.fromJson(Map<String, dynamic> json) {
    return StoryItem(JsonUtil.prettyDate(json['DateTime']), json['Type'], json['Info'] ?? 'No data');
  }
}
