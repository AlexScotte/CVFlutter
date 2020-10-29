import 'package:cvflutter/model/experience.dart';

class Client {
  Experience experience;
  int id;
  String imageUrl;
  String location;
  String name;
  String site;

  Client(
      {this.experience,
      this.id,
      this.imageUrl,
      this.location,
      this.name,
      this.site});

  Client.fromJson(Map<String, dynamic> json) {
    experience = json['experience'] != null
        ? new Experience.fromJson(json['experience'])
        : null;
    id = json['id'];
    imageUrl = json['imageUrl'];
    location = json['location'];
    name = json['name'];
    site = json['site'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.experience != null) {
      data['experience'] = this.experience.toJson();
    }
    data['id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['location'] = this.location;
    data['name'] = this.name;
    data['site'] = this.site;
    return data;
  }
}
