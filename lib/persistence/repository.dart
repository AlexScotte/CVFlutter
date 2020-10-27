import 'package:cvflutter/model/profile.dart';
import 'package:cvflutter/model/skill.dart';
import 'api_provider.dart';

class Repository {
  ApiProvider appApiProvider = ApiProvider();

  Future<Profile> getProfile() => appApiProvider.fetchProfile();
  Future<List<Skill>> getDistinctSkills() =>
      appApiProvider.fetchDistinctSkills();
}
