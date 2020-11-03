import 'package:cvflutter/model/contact.dart';
import 'package:cvflutter/persistence/repository.dart';
import 'package:rxdart/rxdart.dart';

final contactBloc = ContactBloc();

class ContactBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<Contact>();

  Observable<Contact> get contact => _fetcher.stream;

  fetchContact() async {
    Contact response = await _repository.getContact();
    _fetcher.sink.add(response);
  }

  dispose() {
    _fetcher.close();
  }
}
