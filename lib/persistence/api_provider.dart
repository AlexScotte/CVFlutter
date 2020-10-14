import 'dart:convert';
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
}
