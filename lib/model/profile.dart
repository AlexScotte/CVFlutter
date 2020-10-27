import 'package:cvflutter/model/skill.dart';

import 'hobby.dart';

class Profile {
  int age;
  String backgroundImageUrl;
  String birthDate;
  String description;
  String firstName;
  List<Hobby> hobbies;
  String imageUrl;
  String job;
  String lastName;
  String location;
  List<Skill> distinctSkills;

  Profile(
      {this.age,
      this.backgroundImageUrl,
      this.birthDate,
      this.description,
      this.firstName,
      this.hobbies,
      this.imageUrl,
      this.job,
      this.lastName,
      this.location});

  Profile.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    backgroundImageUrl = json['backgroundImageUrl'];
    birthDate = json['birthDate'];
    description = json['description'];
    firstName = json['firstName'];
    if (json['hobbies'] != null) {
      hobbies = new List<Hobby>();
      json['hobbies'].forEach((v) {
        hobbies.add(new Hobby.fromJson(v));
      });
    }
    imageUrl = json['imageUrl'];
    job = json['job'];
    lastName = json['lastName'];
    location = json['location'];
  }
}
