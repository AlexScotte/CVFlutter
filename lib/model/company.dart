import 'package:cvflutter/model/client.dart';

class Company {
  List<Client> clients;
  String dateEnd;
  String dateStart;
  String department;
  int id;
  String job;
  String name;
  String town;

  Company(
      {this.clients,
      this.dateEnd,
      this.dateStart,
      this.department,
      this.id,
      this.job,
      this.name,
      this.town});

  Company.fromJson(Map<String, dynamic> json) {
    if (json['clients'] != null) {
      clients = new List<Client>();
      json['clients'].forEach((v) {
        clients.add(new Client.fromJson(v));
      });
    }
    dateEnd = json['dateEnd'];
    dateStart = json['dateStart'];
    department = json['department'];
    id = json['id'];
    job = json['job'];
    name = json['name'];
    town = json['town'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.clients != null) {
      data['clients'] = this.clients.map((v) => v.toJson()).toList();
    }
    data['dateEnd'] = this.dateEnd;
    data['dateStart'] = this.dateStart;
    data['department'] = this.department;
    data['id'] = this.id;
    data['job'] = this.job;
    data['name'] = this.name;
    data['town'] = this.town;
    return data;
  }
}
