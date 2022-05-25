import 'package:flutter/material.dart';

class MainPageNav extends ChangeNotifier{
  int _pageIndex = 0;

  MainPageNav();

  int getPageIndex()=> _pageIndex;

  void changeTab(int index){
    _pageIndex = index;
    notifyListeners();
  }
}