import 'package:cvflutter/model/client.dart';

class Company {
  static String kId = 'id';
  static String kClients = 'clients';
  static String kDateEnd = 'dateEnd';
  static String kDateStart = 'dateStart';
  static String kDepartment = 'department';
  static String kJob = 'job';
  static String kName = 'name';
  static String kTown = 'town';

  int id;
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
    id = json[kId];
    dateEnd = json[kDateEnd];
    dateStart = json[kDateStart];
    department = json[kDepartment];
    job = json[kJob];
    name = json[kName];
    town = json[kTown];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
