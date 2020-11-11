class Formation {
  static String kDate = 'date';
  static String kDescription = 'description';
  static String kEstablishment = 'establishment';
  static String kId = 'id';
  static String kName = 'name';
  static String kTown = 'town';
  static String kUrl = 'url';

  String date;
  String description;
  String establishment;
  int id;
  String name;
  String town;
  String url;

  Formation(
      {this.date,
      this.description,
      this.establishment,
      this.id,
      this.name,
      this.town,
      this.url});

  Formation.fromJson(Map<String, dynamic> json) {
    date = json[kDate];
    description = json[kDescription];
    establishment = json[kEstablishment];
    id = json[kId];
    name = json[kName];
    town = json[kTown];
    url = json[kUrl];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[kDate] = this.date;
    data[kDescription] = this.description;
    data[kEstablishment] = this.establishment;
    data[kId] = this.id;
    data[kName] = this.name;
    data[kTown] = this.town;
    data[kUrl] = this.url;
    return data;
  }

  static String prepareTable() {
    return "id INTEGER PRIMARY KEY, $kDate TEXT, $kDescription TEXT, $kEstablishment TEXT, $kName TEXT, $kTown TEXT, $kUrl TEXT";
  }
}
