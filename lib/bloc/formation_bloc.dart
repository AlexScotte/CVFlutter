import 'package:cvflutter/helpers/toast_helper.dart';
import 'package:cvflutter/managers/data_manager.dart';
import 'package:cvflutter/managers/local_database_manager.dart';
import 'package:cvflutter/model/formation.dart';
import 'package:cvflutter/persistence/repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

final formationBloc = FormationBloc();

class FormationBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<List<Formation>>();

  Observable<List<Formation>> get formations => _fetcher.stream;
  bool isFetching = false;

  fetchFormations(BuildContext context) async {
    if (isFetching) return;
    isFetching = true;

    List<Formation> formations = new List<Formation>();

    var isNetworkConnected = await DataManager().checkConnection();
    if (isNetworkConnected) {
      if (DataManager().isLatestLocalDataVersion == null) {
        // Init and check version when  user opens the app the first time without connection
        //and enables it after
        await DataManager().init();
      }
      if (DataManager().isLatestLocalDataVersion) {
        formations = await LocalDatabaseManager().getFormations();
        if (formations == null || formations.isEmpty) {
          formations = await this._repository.getFormations();
          await LocalDatabaseManager().createFormations(formations);
        }
      }
    } else {
      formations = await LocalDatabaseManager().getFormations();
      if (formations == null || formations.isEmpty) {
        ToastHelper.showToastNoData(context);
      } else {
        ToastHelper.showToastNoConnection(context);
      }
    }

    isFetching = false;
    _fetcher.sink.add(formations);
  }

  dispose() {
    _fetcher.close();
  }
}
