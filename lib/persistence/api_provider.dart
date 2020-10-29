import 'dart:convert';
import 'package:cvflutter/model/company.dart';
import 'package:cvflutter/model/skill.dart';
import 'package:http/http.dart' show Client;
import 'package:cvflutter/model/profile.dart';

class ApiProvider {
  Client client = Client();
  final _baseUrl = "https://ascottecv.azurewebsites.net";

  Future<Profile> fetchProfile() async {
    try {
      final response = await client.get("$_baseUrl" + "/profile");
      return Profile.fromJson(json.decode(response.body));
    } catch (error, stacktrace) {
      throw Exception(
          'Failed to load profile ($error stackTrace: $stacktrace")');
    }
  }

  Future<List<Skill>> fetchDistinctSkills() async {
    try {
      final response =
          await client.get("$_baseUrl" + "/companies/distinctSkills");
      var skills = (json.decode(response.body) as List)
          .map((i) => new Skill.fromJson(i))
          .toList();
      return skills;
    } catch (error, stacktrace) {
      throw Exception(
          'Failed to load profile ($error stackTrace: $stacktrace")');
    }
  }

  Future<List<Company>> fetchCompanies() async {
    try {
      final response = await client.get("$_baseUrl" + "/companies");
      var companies = (json.decode(response.body) as List)
          .map((i) => new Company.fromJson(i))
          .toList();
      return companies;
    } catch (error, stacktrace) {
      throw Exception(
          'Failed to load profile ($error stackTrace: $stacktrace")');
    }
  }
}
