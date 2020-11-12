import 'package:cvflutter/model/experience_details.dart';
import 'package:cvflutter/model/skill.dart';

class Experience {
  static String kId = 'id';
  static String kDetails = 'details';
  static String kDuration = 'duration';
  static String kDateStart = 'dateStart';
  static String kDepartment = 'department';
  static String kJob = 'job';
  static String kSkills = 'skills';
  static String fkExperienceId = 'experience_id';
  static String fkClientId = 'client_id';

  int id;
  ExperienceDetails details;
  String duration;
  String job;
  List<Skill> skills;

  Experience({this.details, this.duration, this.job, this.skills});

  Experience.fromJson(Map<String, dynamic> json) {
    details = json[kDetails] != null
        ? new ExperienceDetails.fromJson(json[kDetails])
        : null;
    id = json[kId];
    duration = json[kDuration];
    job = json[kJob];
    if (json[kSkills] != null) {
      skills = new List<Skill>();
      json[kSkills].forEach((v) {
        skills.add(new Skill.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[kDuration] = this.duration;
    data[kJob] = this.job;
    return data;
  }

  static String prepareTable() {
    return "id INTEGER PRIMARY KEY, $kDuration TEXT, $kJob TEXT";
  }
}
