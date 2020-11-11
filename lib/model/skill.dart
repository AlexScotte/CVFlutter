class Skill {
  static String kId = 'id';
  static String kImportant = 'important';
  static String kName = 'name';
  static String fkSkillId = 'skill_id';

  int id;
  int important;
  String name;

  Skill({this.important, this.name});

  Skill.fromJson(Map<String, dynamic> json) {
    id = json[kId];
    important = json[kImportant];
    name = json[kName];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[kImportant] = this.important;
    data[kName] = this.name;
    return data;
  }

  static String prepareTable() {
    return "id INTEGER PRIMARY KEY, $kName TEXT, $kImportant INTEGER";
  }
}
