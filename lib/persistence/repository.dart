import 'package:cvflutter/model/company.dart';
import 'package:cvflutter/model/contact.dart';
import 'package:cvflutter/model/formation.dart';
import 'package:cvflutter/model/informations.dart';
import 'package:cvflutter/model/profile.dart';
import 'package:cvflutter/model/skill.dart';
import 'api_provider.dart';

class Repository {
  ApiProvider appApiProvider = ApiProvider();

  Future<Profile> getProfile() => appApiProvider.fetchProfile();
  Future<List<Skill>> getDistinctSkills() =>
      appApiProvider.fetchDistinctSkills();

  Future<List<Company>> getCompanies() => appApiProvider.fetchCompanies();
  Future<List<Formation>> getFormations() => appApiProvider.fetchFormations();
  Future<Contact> getContact() => appApiProvider.fetchContact();
  Future<Informations> getInformations() => appApiProvider.fetchInformations();
}
