import 'package:cvflutter/helpers/toast_helper.dart';
import 'package:cvflutter/managers/data_manager.dart';
import 'package:cvflutter/managers/local_database_manager.dart';
import 'package:cvflutter/model/contact.dart';
import 'package:cvflutter/persistence/repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

final contactBloc = ContactBloc();

class ContactBloc {
  Repository _repository = Repository();

  final _fetcher = PublishSubject<Contact>();

  Observable<Contact> get contact => _fetcher.stream;
  bool isFetching = false;

  fetchContact(BuildContext context) async {
    if (isFetching) return;
    isFetching = true;

    Contact contact;

    var isNetworkConnected = await DataManager().checkConnection();
    if (isNetworkConnected) {
      if (DataManager().isLatestLocalDataVersion == null) {
        // Init and check version when  user opens the app the first time without connection
        //and enables it after
        await DataManager().init();
      }
      if (DataManager().isLatestLocalDataVersion) {
        contact = await this._getLocalDataContact();
        if (contact == null) {
          contact = await _repository.getContact();
          await _saveLocalDataContact(contact);
        }
      }
    } else {
      contact = await this._getLocalDataContact();
      if (contact == null) {
        ToastHelper.showToastNoData(context);
      } else {
        ToastHelper.showToastNoConnection(context);
      }
    }

    isFetching = false;
    _fetcher.sink.add(contact);
  }

  Future<void> _saveLocalDataContact(Contact contact) async {
    await LocalDatabaseManager().createContact(contact);
    if (contact.externalLinks != null && contact.externalLinks.isNotEmpty) {
      await LocalDatabaseManager().createExternalLinks(contact.externalLinks);
    }
  }

  Future<Contact> _getLocalDataContact() async {
    Contact contact;
    var contacts = await LocalDatabaseManager().getContact();
    if (contacts != null && contacts.isNotEmpty) {
      contact = contacts.first;
      if (contact != null)
        contact.externalLinks = await LocalDatabaseManager().getExternalLinks();
    }
    return contact;
  }

  dispose() {
    _fetcher.close();
  }
}
