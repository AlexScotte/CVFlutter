import 'package:cvflutter/model/hobby.dart';
import 'package:cvflutter/model/profile.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseManager {
  static final LocalDatabaseManager _localDatabaseManager =
      LocalDatabaseManager._build();
  LocalDatabaseManager._build();

  factory LocalDatabaseManager() {
    return _localDatabaseManager;
  }

  Database _database;
  final String kProfile = "profile";
  final String kHobbies = "hobbies";

  init() async {
    // Open the database and store the reference.
    _database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'cv_database.db'),
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    await _database.execute("DROP TABLE IF EXISTS $kProfile");
    await _database.execute("DROP TABLE IF EXISTS $kHobbies");

    await _database.execute("CREATE TABLE ${Profile.prepareTable()}");
    await _database.execute("CREATE TABLE ${Hobby.prepareTable()}");
  }

  void createProfile(Profile profile) {
    _database.insert(kProfile, profile.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Profile>> getProfile() async {
    var maps = await _database.query(kProfile);
    return List.generate(maps.length, (i) {
      return Profile.fromJson(maps[i]);
    });
  }

  void createHobbies(List<Hobby> hobbies) {
    for (var hobby in hobbies) {
      _database.insert(kHobbies, hobby.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Hobby>> getHobbies() async {
    var maps = await _database.query(kHobbies);
    return List.generate(maps.length, (i) {
      return Hobby.fromJson(maps[i]);
    });
  }
}
