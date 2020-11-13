import 'package:cvflutter/managers/data_manager.dart';
import 'package:cvflutter/managers/local_database_manager.dart';
import 'package:cvflutter/model/formation.dart';
import 'package:cvflutter/persistence/repository.dart';
import 'package:rxdart/rxdart.dart';

final formationBloc = FormationBloc();

class FormationBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<List<Formation>>();

  Observable<List<Formation>> get formations => _fetcher.stream;
  bool isFetching = false;

  fetchFormations() async {
    if (isFetching) return;
    isFetching = true;

    List<Formation> formations = new List<Formation>();

    var isNetworkConnected = await DataManager().checkConnection();
    if (isNetworkConnected) {
      if (DataManager().isLatestLocalDataVersion) {
        formations = await LocalDatabaseManager().getFormations();
        if (formations == null || formations.isEmpty) {
          formations = await this._repository.getFormations();
          await LocalDatabaseManager().createFormations(formations);
        }
      }
    } else {
      formations = await LocalDatabaseManager().getFormations();
    }

    isFetching = false;
    _fetcher.sink.add(formations);
  }

  dispose() {
    _fetcher.close();
  }
}
