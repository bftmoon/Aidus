class FixInfo {
  final String id; // service as provider for logging
  final String name;
  final String description;
  bool isExpanded = false;

  FixInfo(this.id, this.name, this.description);

  factory FixInfo.fromJson(Map<String, dynamic> json) {
    return FixInfo(json['ID'].toString(), json['Name'], json['Description']);
  }
}
