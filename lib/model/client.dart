import 'package:cvflutter/model/experience.dart';

class Client {
  static String kExperience = 'experience';
  static String kImageUrl = 'imageUrl';
  static String kLocation = 'location';
  static String kName = 'name';
  static String kSite = 'site';
  static String fkCompanyId = 'company_id';

  Experience experience;
  String imageUrl;
  String location;
  String name;
  String site;

  Client({this.experience, this.imageUrl, this.location, this.name, this.site});

  Client.fromJson(Map<String, dynamic> json) {
    experience = json[kExperience] != null
        ? new Experience.fromJson(json[kExperience])
        : null;
    imageUrl = json[kImageUrl];
    location = json[kLocation];
    name = json[kName];
    site = json[kSite];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // if (this.experience != null) {
    //   data['experience'] = this.experience.toMap();
    // }
    data[kImageUrl] = this.imageUrl;
    data[kLocation] = this.location;
    data[kName] = this.name;
    data[kSite] = this.site;
    return data;
  }

  static String prepareTable() {
    return "id INTEGER PRIMARY KEY, $kImageUrl TEXT, $kLocation TEXT, $kName TEXT, $kSite TEXT";
  }
}
