class Informations {
  static String kVersion = 'version';

  double version;

  Informations({this.version});

  Informations.fromJson(Map<String, dynamic> json) {
    version = json[kVersion];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[kVersion] = this.version;
    return data;
  }

  static String prepareTable() {
    return "id INTEGER PRIMARY KEY, $kVersion TEXT";
  }
}
