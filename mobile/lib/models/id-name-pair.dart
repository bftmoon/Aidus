class IdNamePair {
  String id;
  String name;

  IdNamePair(this.id, this.name);

  factory IdNamePair.fromJson(Map<String, dynamic> json) {
    return IdNamePair(json['ID'].toString(), json['Name']);
  }

  @override
  String toString() {
    return 'IdNamePair{id: $id, name: $name}';
  }
}
