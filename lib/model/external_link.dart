class ExternalLink {
  static String kId = 'id';
  static String kName = 'name';
  static String kImageUrl = 'imageUrl';
  static String kUrl = 'url';

  int id;
  String imageUrl;
  String name;
  String url;

  ExternalLink({this.id, this.imageUrl, this.name, this.url});

  ExternalLink.fromJson(Map<String, dynamic> json) {
    id = json[kId];
    imageUrl = json[kImageUrl];
    name = json[kName];
    url = json[kUrl];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[kId] = this.id;
    data[kImageUrl] = this.imageUrl;
    data[kName] = this.name;
    data[kUrl] = this.url;
    return data;
  }

  static String prepareTable() {
    return "id INTEGER PRIMARY KEY, $kName TEXT,$kImageUrl TEXT,$kUrl TEXT";
  }
}
