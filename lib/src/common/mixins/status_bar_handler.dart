import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

abstract class StatusBarHandler {

  changeStatusBarStyle(Color color, StatusBarStyle style) async {
    await FlutterStatusbarManager.setColor(color, animated: true);
    await FlutterStatusbarManager.setStyle(style);
  }
}