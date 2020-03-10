import '../utils/json_util.dart';

class Issue {
  final String id;
  final String title;
  final String priority;
  final String openedAt, updatedAt;
  final Map<String, dynamic> labels;
  final String description;
  final String status;
  final String parentUrl;

  Issue(
      {this.id,
      this.title,
      this.priority,
      this.openedAt,
      this.updatedAt,
      this.labels,
      this.description,
      this.status,
      this.parentUrl});

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
        id: json['ID'],
        title: json['Title'],
        priority: JsonUtil.capitalizeFirst(json, 'Severity'),
        labels: json['Labels'],
        openedAt: JsonUtil.prettyDate(json['OpenedAt']),
        updatedAt: JsonUtil.prettyDate(json['UpdatedAt']),
        description: json['Description'],
        status: json['Status'].toString().toUpperCase(),
        parentUrl: json['ParentServiceURL']);
  }

  String labelsString() {
    StringBuffer sb = new StringBuffer();
    labels.forEach((k, v) => sb.writeAll([k, ': ', v, '\n']));
    return sb.toString().trimRight();
  }

  String datesString() {
    return 'Opened at: ' + openedAt + '\nUpdated at: ' + updatedAt;
  }
}
