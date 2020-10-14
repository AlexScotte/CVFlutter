import 'package:cvflutter/model/profile.dart';
import 'api_provider.dart';

class Repository {
  ApiProvider appApiProvider = ApiProvider();

  Future<Profile> fetchProfile() => appApiProvider.fetchProfile();
}
