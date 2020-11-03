class Formation {
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
    date = json['date'];
    description = json['description'];
    establishment = json['establishment'];
    id = json['id'];
    name = json['name'];
    town = json['town'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['description'] = this.description;
    data['establishment'] = this.establishment;
    data['id'] = this.id;
    data['name'] = this.name;
    data['town'] = this.town;
    data['url'] = this.url;
    return data;
  }
}
