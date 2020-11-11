class ExperienceDetails {
  static String kId = 'id';
  static String kContext = 'context';
  static String kMissions = 'missions';
  static String fkEperienceId = 'experience_id';
  int id;
  String context;
  String missions;

  ExperienceDetails({this.context, this.missions});

  ExperienceDetails.fromJson(Map<String, dynamic> json) {
    id = json[kId];
    context = json[kContext];
    missions = json[kMissions];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[kContext] = this.context;
    data[kMissions] = this.missions;
    return data;
  }

  static String prepareTable() {
    return "id INTEGER PRIMARY KEY, $kContext TEXT, $kMissions TEXT";
  }
}
