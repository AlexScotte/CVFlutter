import 'package:cvflutter/model/external_link.dart';

class Contact {
  String cvUrl;
  String email;
  List<ExternalLink> externalLinks;
  String phone;

  Contact({this.cvUrl, this.email, this.externalLinks, this.phone});

  Contact.fromJson(Map<String, dynamic> json) {
    cvUrl = json['cvUrl'];
    email = json['email'];
    if (json['externalLinks'] != null) {
      externalLinks = new List<ExternalLink>();
      json['externalLinks'].forEach((v) {
        externalLinks.add(new ExternalLink.fromJson(v));
      });
    }
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cvUrl'] = this.cvUrl;
    data['email'] = this.email;
    if (this.externalLinks != null) {
      data['externalLinks'] =
          this.externalLinks.map((v) => v.toJson()).toList();
    }
    data['phone'] = this.phone;
    return data;
  }
}
