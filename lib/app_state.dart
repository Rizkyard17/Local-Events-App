import 'package:flutter/material.dart';

class AppState with ChangeNotifier {

  int selectedCategoryId = 0;

  void updateCategoryId(int selectedCategoryId) {
    this.selectedCategoryId  = selectedCategoryId;
    notifyListeners();
  }
}