class ExternalLink {
  int id;
  String imageUrl;
  String name;
  String url;

  ExternalLink({this.id, this.imageUrl, this.name, this.url});

  ExternalLink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
