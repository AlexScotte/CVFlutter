import 'package:cvflutter/managers/data_manager.dart';
import 'package:cvflutter/managers/local_database_manager.dart';
import 'package:cvflutter/model/profile.dart';
import 'package:cvflutter/persistence/repository.dart';
import 'package:rxdart/rxdart.dart';

final profileBloc = ProfileBloc();

class ProfileBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<Profile>();

  Observable<Profile> get profile => _fetcher.stream;
  bool isFetching = false;

  fetchProfile() async {
    // Avoid to create or get data several time when widget is building
    if (isFetching) return;
    isFetching = true;
    Profile profile;

    var isNetworkConnected = await DataManager().checkConnection();
    if (isNetworkConnected) {
      if (DataManager().isLatestLocalDataVersion == null) {
        // Init and check version when  user opens the app the first time without connection
        //and enables it after
        await DataManager().init();
      }

      if (DataManager().isLatestLocalDataVersion) {
        profile = await this._getLocalDataProfile();
        if (profile == null) {
          profile = await _repository.getProfile();
          profile.distinctSkills = await _repository.getDistinctSkills();
          this._saveLocalDataProfile(profile);
        }
      }
    } else {
      profile = await this._getLocalDataProfile();
    }

    isFetching = false;
    _fetcher.sink.add(profile);
  }

  Future<void> _saveLocalDataProfile(Profile profile) async {
    await LocalDatabaseManager().createProfile(profile);
    await LocalDatabaseManager().createHobbies(profile.hobbies);
    await LocalDatabaseManager()
        .createSkills(-1, profile.distinctSkills, false);
  }

  Future<Profile> _getLocalDataProfile() async {
    Profile profile;
    var profiles = await LocalDatabaseManager().getProfile();
    if (profiles != null && profiles.isNotEmpty) {
      profile = profiles.first;
      profile.hobbies = await LocalDatabaseManager().getHobbies();
      profile.distinctSkills =
          await LocalDatabaseManager().getDistinctSkills(true);
    }

    return profile;
  }

  dispose() {
    _fetcher.close();
  }
}
