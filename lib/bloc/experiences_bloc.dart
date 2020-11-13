import 'package:cvflutter/managers/data_manager.dart';
import 'package:cvflutter/managers/local_database_manager.dart';
import 'package:cvflutter/model/company.dart';
import 'package:cvflutter/persistence/repository.dart';
import 'package:rxdart/rxdart.dart';

final profileBloc = ExperiencesBloc();

class ExperiencesBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<List<Company>>();

  Observable<List<Company>> get companies => _fetcher.stream;
  bool isFetching = false;
  Future<void> fetchCompanies() async {
    // Avoid to create or get data several time when widget is building
    if (isFetching) return;
    isFetching = true;

    List<Company> companies = new List<Company>();

    var isNetworkConnected = await DataManager().checkConnection();
    if (isNetworkConnected) {
      if (DataManager().isLatestLocalDataVersion == null) {
        // Init and check version when  user opens the app the first time without connection
        //and enables it after
        await DataManager().init();
      }
      if (DataManager().isLatestLocalDataVersion) {
        companies = await this._getLocalDataCompanies();
        if (companies == null || companies.isEmpty) {
          companies = await _repository.getCompanies();
          await LocalDatabaseManager().createCompanies(companies);
        }
      }
    } else {
      companies = await this._getLocalDataCompanies();
    }
    _fetcher.sink.add(companies);
  }

  Future<List<Company>> _getLocalDataCompanies() async {
    // Get companies
    var companies = await LocalDatabaseManager().getCompanies();
    for (var company in companies) {
      // Get clients by company ID
      company.clients =
          await LocalDatabaseManager().getClientsByCompanyId(company.id);

      if (company.clients != null && company.clients.isNotEmpty) {
        for (var client in company.clients) {
          // Get experience by client ID
          var experiences =
              await LocalDatabaseManager().getExperienceByClientId(client.id);
          client.experience = experiences?.first;

          // Get experience details by experience ID
          var details = await LocalDatabaseManager()
              .getExperienceDetailsByExperienceId(client.experience.id);
          client.experience.details = details.first;

          // Get skills by experience ID
          client.experience.skills = await LocalDatabaseManager()
              .getSkillByExperienceId(client.experience.id);
        }
      }
    }
    return companies;
  }

  dispose() {
    _fetcher.close();
  }
}
