final String kId = 'id';
final String kName = 'name';

class Hobby {
  int id;
  String name;

  Hobby({this.id, this.name});

  Hobby.fromJson(Map<String, dynamic> json) {
    id = json[kId];
    name = json[kName];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[kId] = this.id;
    data[kName] = this.name;
    return data;
  }

  static String prepareTable() {
    return "$kId INTEGER, $kName TEXT";
  }
}
