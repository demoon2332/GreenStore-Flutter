import 'package:flutter/cupertino.dart';

import './UserInfoRepos.dart';

class MemUserInfoRepos extends UserInfoRepos with ChangeNotifier{
  String name = "Nguyễn Thị Minh Khai";
  String address = "1 Cách Mạng Tháng 8, Phường 1, Quận 1, TP.HCM";
  String phone = "0918111222";

  @override
  String getAddress() => address;

  @override
  String getName() => name;

  @override
  String getPhone() => phone;

  @override
  void setAddress(String address) {
    this.address = address;
    notifyListeners();
  }

  @override
  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  @override
  void setPhone(String phone) {
    phone = phone;
    notifyListeners();
  }

  void setAllData(String address, String name, String phone){
    this.address = address;
    this.name = name;
    this.phone = phone;
    notifyListeners();
  }

}