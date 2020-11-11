import 'package:cvflutter/model/external_link.dart';

class Contact {
  static String kCvUrl = 'cvUrl';
  static String kEmail = 'email';
  static String kExternalLinks = 'externalLinks';
  static String kPhone = 'phone';

  String cvUrl;
  String email;
  List<ExternalLink> externalLinks;
  String phone;

  Contact({this.cvUrl, this.email, this.externalLinks, this.phone});

  Contact.fromJson(Map<String, dynamic> json) {
    cvUrl = json[kCvUrl];
    email = json[kEmail];
    if (json[kExternalLinks] != null) {
      externalLinks = new List<ExternalLink>();
      json[kExternalLinks].forEach((v) {
        externalLinks.add(new ExternalLink.fromJson(v));
      });
    }
    phone = json[kPhone];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[kCvUrl] = this.cvUrl;
    data[kEmail] = this.email;
    // if (this.externalLinks != null) {
    //   data[kExternalLinks] = this.externalLinks.map((v) => v.toJson()).toList();
    // }
    data[kPhone] = this.phone;
    return data;
  }

  static String prepareTable() {
    return "id INTEGER PRIMARY KEY $kCvUrl TEXT,$kEmail TEXT,$kPhone TEXT";
  }
}
