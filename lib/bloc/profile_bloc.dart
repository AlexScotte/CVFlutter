import 'package:cvflutter/model/profile.dart';
import 'package:cvflutter/persistence/repository.dart';
import 'package:rxdart/rxdart.dart';

final profileBloc = ProfileBloc();

class ProfileBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<Profile>();

  Observable<Profile> get profile => _fetcher.stream;

  fetchProfile() async {
    Profile response = await _repository.getProfile();
    response.distinctSkills = await _repository.getDistinctSkills();
    _fetcher.sink.add(response);
  }

  dispose() {
    _fetcher.close();
  }
}
