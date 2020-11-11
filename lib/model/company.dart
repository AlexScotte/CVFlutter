import 'package:cvflutter/model/client.dart';

final String kClients = 'clients';
final String kDateEnd = 'dateEnd';
final String kDateStart = 'dateStart';
final String kDepartment = 'department';
final String kJob = 'job';
final String kName = 'name';
final String kTown = 'town';

class Company {
  List<Client> clients;
  String dateEnd;
  String dateStart;
  String department;
  String job;
  String name;
  String town;
  bool isExpanded = true;

  Company(
      {this.clients,
      this.dateEnd,
      this.dateStart,
      this.department,
      this.job,
      this.name,
      this.town});

  Company.fromJson(Map<String, dynamic> json) {
    if (json[kClients] != null) {
      clients = new List<Client>();
      json[kClients].forEach((v) {
        clients.add(new Client.fromJson(v));
      });
    }
    dateEnd = json[kDateEnd];
    dateStart = json[kDateStart];
    department = json[kDepartment];
    job = json[kJob];
    name = json[kName];
    town = json[kTown];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // if (this.clients != null) {
    //   data[kClients] = this.clients.map((v) => v.toMap()).toList();
    // }
    data[kDateEnd] = this.dateEnd;
    data[kDateStart] = this.dateStart;
    data[kDepartment] = this.department;
    data[kJob] = this.job;
    data[kName] = this.name;
    data[kTown] = this.town;
    return data;
  }

  static String prepareTable() {
    return "id INTEGER PRIMARY KEY, $kDateEnd TEXT, $kDateStart TEXT, $kDepartment TEXT, $kJob TEXT, $kName TEXT, $kTown TEXT";
  }
}
