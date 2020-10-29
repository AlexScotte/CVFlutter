import 'package:cvflutter/model/experience_details.dart';
import 'package:cvflutter/model/skill.dart';

class Experience {
  ExperienceDetails details;
  String duration;
  int id;
  String job;
  List<Skill> skills;

  Experience({this.details, this.duration, this.id, this.job, this.skills});

  Experience.fromJson(Map<String, dynamic> json) {
    details = json['details'] != null
        ? new ExperienceDetails.fromJson(json['details'])
        : null;
    duration = json['duration'];
    id = json['id'];
    job = json['job'];
    if (json['skills'] != null) {
      skills = new List<Skill>();
      json['skills'].forEach((v) {
        skills.add(new Skill.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.toJson();
    }
    data['duration'] = this.duration;
    data['id'] = this.id;
    data['job'] = this.job;
    if (this.skills != null) {
      data['skills'] = this.skills.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
