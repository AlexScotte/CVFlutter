class Skill {
  int id;
  int important;
  String name;

  Skill({this.id, this.important, this.name});

  Skill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    important = json['important'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['important'] = this.important;
    data['name'] = this.name;
    return data;
  }
}
