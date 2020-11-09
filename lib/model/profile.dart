import 'package:cvflutter/model/skill.dart';

import 'hobby.dart';

final String kAge = 'age';
final String kBackgroundImageUrl = 'backgroundImageUrl';
final String kBirthDate = 'birthDate';
final String kDescription = 'description';
final String kFirstName = 'firstName';
final String kHobbies = 'hobbies';
final String kImageUrl = 'imageUrl';
final String kJob = 'job';
final String kLastName = 'lastName';
final String kLocation = 'location';

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
    age = json[kAge];
    backgroundImageUrl = json[kBackgroundImageUrl];
    birthDate = json[kBirthDate];
    description = json[kDescription];
    firstName = json[kFirstName];
    if (json[kHobbies] != null) {
      hobbies = new List<Hobby>();
      json[kHobbies].forEach((v) {
        hobbies.add(new Hobby.fromJson(v));
      });
    }
    imageUrl = json[kImageUrl];
    job = json[kJob];
    lastName = json[kLastName];
    location = json[kLocation];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[kAge] = this.age;
    data[kBackgroundImageUrl] = this.backgroundImageUrl;
    data[kBirthDate] = this.birthDate;
    data[kDescription] = this.description;
    data[kFirstName] = this.firstName;
    // if (this.hobbies != null) {
    //   data[kHobbies] = this.hobbies.map((v) => v.toJson()).toList();
    // }
    data[kImageUrl] = this.imageUrl;
    data[kJob] = this.job;
    data[kLastName] = this.lastName;
    data[kLocation] = this.location;
    return data;
  }

  static String prepareTable() {
    return "profile(id INTEGER PRIMARY KEY, $kAge INTEGER, $kBackgroundImageUrl TEXT, $kBirthDate TEXT, $kDescription TEXT, $kFirstName TEXT, $kImageUrl TEXT, $kJob TEXT, $kLastName TEXT, $kLocation TEXT )";
  }
}
