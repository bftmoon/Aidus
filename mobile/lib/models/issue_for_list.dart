import '../utils/json_util.dart';

class IssueForList {
  final String id;
  final String title;
  final String priority;
  final String date;
  final String status;

  IssueForList({this.id, this.title, this.priority, this.date, this.status});

  factory IssueForList.fromJson(Map<String, dynamic> json) {
    return IssueForList(
        id: json['ID'],
        title: json['Title'],
        priority: JsonUtil.capitalizeFirst(json, 'Severity'),
        date: JsonUtil.prettyDate(json['UpdatedAt']),
        status: JsonUtil.capitalizeFirst(json, 'Status'));
  }
}
