import 'package:cvflutter/model/client.dart';
import 'package:cvflutter/model/company.dart';
import 'package:cvflutter/model/contact.dart';
import 'package:cvflutter/model/experience.dart';
import 'package:cvflutter/model/experience_details.dart';
import 'package:cvflutter/model/external_link.dart';
import 'package:cvflutter/model/formation.dart';
import 'package:cvflutter/model/hobby.dart';
import 'package:cvflutter/model/informations.dart';
import 'package:cvflutter/model/profile.dart';
import 'package:cvflutter/model/skill.dart';
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
  final String kCompanies = "companies";
  final String kClients = "clients";
  final String kExperience = "experience";
  final String kExperienceDetails = "experienceDetails";
  final String kSkills = "skills";
  final String kLinkSkillExperience = "link_skill_experience";
  final String kFormations = "formations";
  final String kContact = "contact";
  final String kExternalLinks = "externalLinks";
  final String kInformations = "informations";

  init() async {
    // Open the database and store the reference.
    _database = await openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'cv_database.db'),
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1, onConfigure: (Database db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    });

    await _prepareTables();
  }

  Future<void> _prepareTables() async {
    await _dropTables();
    await _createTables();
  }

  Future<void> _dropTables() async {
    await _database.execute("DROP TABLE IF EXISTS $kLinkSkillExperience");
    await _database.execute("DROP TABLE IF EXISTS $kSkills");
    await _database.execute("DROP TABLE IF EXISTS $kExperienceDetails");
    await _database.execute("DROP TABLE IF EXISTS $kExperience");
    await _database.execute("DROP TABLE IF EXISTS $kClients");
    await _database.execute("DROP TABLE IF EXISTS $kCompanies");
    await _database.execute("DROP TABLE IF EXISTS $kProfile");
    await _database.execute("DROP TABLE IF EXISTS $kHobbies");
    await _database.execute("DROP TABLE IF EXISTS $kFormations");
    await _database.execute("DROP TABLE IF EXISTS $kContact");
    await _database.execute("DROP TABLE IF EXISTS $kExternalLinks");
    await _database.execute("DROP TABLE IF EXISTS $kInformations");
  }

  Future<void> _createTables() async {
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS $kInformations (${Informations.prepareTable()})");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS $kProfile (${Profile.prepareTable()})");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS $kHobbies(${Hobby.prepareTable()})");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS $kCompanies (${Company.prepareTable()})");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS $kClients (${Client.prepareTable()}, ${Client.fkCompanyId} INTEGER, FOREIGN KEY(${Client.fkCompanyId}) REFERENCES $kCompanies(id))");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS $kExperience (${Experience.prepareTable()}, ${Experience.fkClientId} INTEGER, FOREIGN KEY(${Experience.fkClientId}) REFERENCES $kClients(id))");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS $kExperienceDetails (${ExperienceDetails.prepareTable()}, ${ExperienceDetails.fkEperienceId} INTEGER, FOREIGN KEY(${ExperienceDetails.fkEperienceId}) REFERENCES $Experience(id))");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS $kSkills(${Skill.prepareTable()})");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS $kLinkSkillExperience (${Experience.fkExperienceId} INTEGER, ${Skill.fkSkillId} INTEGER,FOREIGN KEY(${Experience.fkExperienceId}) REFERENCES $kExperience(id),FOREIGN KEY(${Skill.fkSkillId}) REFERENCES $kSkills(id))");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS $kFormations(${Formation.prepareTable()})");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS $kContact (${Contact.prepareTable()})");
    await _database.execute(
        "CREATE TABLE IF NOT EXISTS $kExternalLinks(${ExternalLink.prepareTable()})");
  }

/* #region create */
  Future<void> createProfile(Profile profile) async {
    await _database.insert(kProfile, profile.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> createHobbies(List<Hobby> hobbies) async {
    for (var hobby in hobbies) {
      await _database.insert(kHobbies, hobby.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> createCompanies(List<Company> companies) async {
    for (var company in companies) {
      var idCompany = await _database.insert(kCompanies, company.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      await this.createClients(idCompany, company.clients);
    }
  }

  Future<void> createClients(int idCompany, List<Client> clients) async {
    for (var client in clients) {
      // Add foreign key
      var map = client.toMap();
      map[Client.fkCompanyId] = idCompany;
      var idClient = await _database.insert(kClients, map);

      await this.createExperience(idClient, client.experience);
    }
  }

  Future<void> createExperience(int idClient, Experience xp) async {
    // Add foreign key
    var map = xp.toMap();
    map[Experience.fkClientId] = idClient;

    var idExp = await _database.insert(kExperience, map,
        conflictAlgorithm: ConflictAlgorithm.replace);

    await this.createExperienceDetails(idExp, xp.details);
    await this.createSkills(idExp, xp.skills);
  }

  Future<void> createExperienceDetails(
      int idExp, ExperienceDetails xpDetails) async {
    // Add foreign key
    var map = xpDetails.toMap();
    map[ExperienceDetails.fkEperienceId] = idExp;
    await _database.insert(kExperienceDetails, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> createSkills(int idExp, List<Skill> skills) async {
    for (var skill in skills) {
      // Get id skill if it exists
      List<Map<String, dynamic>> maps = await _database.rawQuery(
          "SELECT id FROM $kSkills WHERE ${Skill.kName} = '${skill.name}'");
      int idSkill = 0;
      if (maps.isNotEmpty) {
        idSkill = maps.first["id"];
      } else {
        // Add new skill if it doesn't exists
        idSkill = await _database.insert(kSkills, skill.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await createLinkSkillExperience(idExp, idSkill);
    }
  }

  Future<void> createLinkSkillExperience(int idExp, int idskill) async {
    Map<String, dynamic> row = {
      Experience.fkExperienceId: idExp,
      Skill.fkSkillId: idskill
    };

    await _database.insert(kLinkSkillExperience, row);
  }

  Future<void> createFormations(List<Formation> formations) async {
    for (var formation in formations) {
      await _database.insert(kFormations, formation.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> createContact(Contact contact) async {
    await _database.insert(kContact, contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> createExternalLinks(List<ExternalLink> extLinks) async {
    for (var extLink in extLinks) {
      await _database.insert(kExternalLinks, extLink.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> createInformations(Informations informations) async {
    await _database.insert(kInformations, informations.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
/* #endregion */

/* #region Get */
  Future<List<Profile>> getProfile() async {
    var maps = await _database.query(kProfile);
    return List.generate(maps.length, (i) {
      return Profile.fromJson(maps[i]);
    });
  }

  Future<List<Company>> getCompanies() async {
    var maps = await _database.query(kCompanies);
    return List.generate(maps.length, (i) {
      return Company.fromJson(maps[i]);
    });
  }

  Future<List<Client>> getClientsByCompanyId(int companyId) async {
    List<Map<String, dynamic>> maps = await _database.rawQuery(
        "SELECT * FROM $kClients WHERE ${Client.fkCompanyId} = '$companyId'");
    return List.generate(maps.length, (i) {
      return Client.fromJson(maps[i]);
    });
  }

  Future<List<Experience>> getExperienceByClientId(int clientId) async {
    List<Map<String, dynamic>> maps = await _database.rawQuery(
        "SELECT * FROM $kExperience WHERE ${Experience.fkClientId} = '$clientId'");
    return List.generate(maps.length, (i) {
      return Experience.fromJson(maps[i]);
    });
  }

  Future<List<ExperienceDetails>> getExperienceDetailsByExperienceId(
      int experienceId) async {
    List<Map<String, dynamic>> maps = await _database.rawQuery(
        "SELECT * FROM $kExperienceDetails WHERE ${ExperienceDetails.fkEperienceId} = '$experienceId'");
    return List.generate(maps.length, (i) {
      return ExperienceDetails.fromJson(maps[i]);
    });
  }

  Future<List<Skill>> getSkillByExperienceId(int experienceId) async {
    List<Map<String, dynamic>> maps = await _database.rawQuery(
        "SELECT * FROM $kSkills LEFT JOIN $kLinkSkillExperience ON $kSkills.id = $kLinkSkillExperience.${Skill.fkSkillId} WHERE $kLinkSkillExperience.${Experience.fkExperienceId} = '$experienceId'");
    return List.generate(maps.length, (i) {
      return Skill.fromJson(maps[i]);
    });
  }

  Future<List<Hobby>> getHobbies() async {
    var maps = await _database.query(kHobbies);
    return List.generate(maps.length, (i) {
      return Hobby.fromJson(maps[i]);
    });
  }

  Future<List<Formation>> getFormations() async {
    var maps = await _database.query(kFormations);
    return List.generate(maps.length, (i) {
      return Formation.fromJson(maps[i]);
    });
  }

  Future<List<Contact>> getContact() async {
    var maps = await _database.query(kContact);
    return List.generate(maps.length, (i) {
      return Contact.fromJson(maps[i]);
    });
  }

  Future<List<ExternalLink>> getExternalLinks() async {
    var maps = await _database.query(kExternalLinks);
    return List.generate(maps.length, (i) {
      return ExternalLink.fromJson(maps[i]);
    });
  }

  Future<List<Informations>> getInformations() async {
    var maps = await _database.query(kInformations);
    return List.generate(maps.length, (i) {
      return Informations.fromJson(maps[i]);
    });
  }
  /* #endregion */
}
