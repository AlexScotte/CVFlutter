import 'package:cvflutter/model/formation.dart';
import 'package:cvflutter/persistence/repository.dart';
import 'package:rxdart/rxdart.dart';

final formationBloc = FormationBloc();

class FormationBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<List<Formation>>();

  Observable<List<Formation>> get formations => _fetcher.stream;

  fetchFormations() async {
    List<Formation> response = await _repository.getFormations();
    _fetcher.sink.add(response);
  }

  dispose() {
    _fetcher.close();
  }
}
