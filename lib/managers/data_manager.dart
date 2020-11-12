import 'package:connectivity/connectivity.dart';
import 'package:cvflutter/managers/local_database_manager.dart';
import 'package:cvflutter/persistence/repository.dart';

class DataManager {
  static final DataManager _dataManager = DataManager._build();

  bool isLatestLocalDataVersion;

  DataManager._build();

  factory DataManager() {
    return _dataManager;
  }
  Repository _repository = Repository();

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return Future.value(false);
    } else if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  Future<void> init() async {
    var localInfos = await LocalDatabaseManager().getInformations();
    double localDataVersion = 0.0;
    if (localInfos != null && localInfos.isNotEmpty) {
      localDataVersion = localInfos.first?.version;
    }

    var isNetworkConnected = await checkConnection();
    if (isNetworkConnected) {
      var infos = await _repository.getInformations();
      var remoteDataVersion = infos.version;

      if (remoteDataVersion > localDataVersion) {
        await LocalDatabaseManager().initLocalDatabase();
        isLatestLocalDataVersion = true;
      } else {
        isLatestLocalDataVersion = false;
      }
    }
  }
}
