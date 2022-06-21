import 'package:flutter/cupertino.dart';

class lang_modeProvider extends ChangeNotifier {
  String appLanguage = 'ar';
  String appMode = 'light';
  void setNewLanguage(String newLang) {
    if (this.appLanguage == newLang) return;

    appLanguage = newLang;
    notifyListeners();
  }

  void setNewMode(String newMode) {
    if (this.appMode == newMode) return;

    appMode = newMode;
    notifyListeners();
  }
}
