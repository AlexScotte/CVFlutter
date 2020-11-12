import 'package:cvflutter/model/informations.dart';
import 'package:cvflutter/persistence/repository.dart';
import 'package:rxdart/rxdart.dart';

final informationsBloc = InformationsBloc();

class InformationsBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<Informations>();

  Observable<Informations> get informations => _fetcher.stream;

  fetchInformations() async {
    Informations response = await _repository.getInformations();
    _fetcher.sink.add(response);
  }

  dispose() {
    _fetcher.close();
  }
}
