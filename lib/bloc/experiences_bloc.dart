import 'package:cvflutter/model/company.dart';
import 'package:cvflutter/persistence/repository.dart';
import 'package:rxdart/rxdart.dart';

final profileBloc = ExperiencesBloc();

class ExperiencesBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<List<Company>>();

  Observable<List<Company>> get companies => _fetcher.stream;

  fetchCompanies() async {
    List<Company> response = await _repository.getCompanies();
    _fetcher.sink.add(response);
  }

  dispose() {
    _fetcher.close();
  }
}
