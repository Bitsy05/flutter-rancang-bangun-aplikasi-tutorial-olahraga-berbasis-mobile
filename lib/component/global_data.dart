import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class GlobalData extends InheritedWidget {
  GlobalData({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  static GlobalData? of(BuildContext context) {
    final GlobalData? result =
        context.dependOnInheritedWidgetOfExactType<GlobalData>();
    return result;
  }

  final Map<String, String> _localData = {};

  setData(String key, String value) {
    _localData[key] = value;
  }

  getData(String key) {
    return _localData[key];
  }

  Future<void> refreshData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("email") != null) {
      _localData["email"] = prefs.getString("email")!;
    }
    if (prefs.getString("password") != null) {
      _localData["password"] = prefs.getString("password")!;
    }
    if (prefs.getString("nama_dpn") != null) {
      _localData["nama_dpn"] = prefs.getString("nama_dpn")!;
    }
  }

  void clearData() {
    _localData.clear();
  }

  @override
  bool updateShouldNotify(GlobalData oldWidget) =>
      _localData != oldWidget._localData;
}
