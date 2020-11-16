import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../app_localizations.dart';

class ToastHelper {
  static void showToast(BuildContext context, String content) {
    Fluttertoast.showToast(
        msg: content,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).accentColor,
        textColor: Theme.of(context).primaryColor,
        fontSize: 11.0);
  }

  static void showToastNoData(BuildContext context) {
    showToast(
        context,
        AppLocalizations.of(context)
            .translate('warning_no_data_connection_desc'));
  }

  static void showToastNoConnection(BuildContext context) {
    showToast(
        context,
        AppLocalizations.of(context)
            .translate('warning_no_connection_new_version_desc'));
  }
}
