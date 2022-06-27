import 'package:flutter/cupertino.dart';
import 'package:greenstore_flutter/models/user.dart';
import 'package:greenstore_flutter/services/user_api.dart';

import '../models/DAO/user_dao.dart';
import './UserInfoRepos.dart';

class MemUserInfoRepos extends UserInfoRepos with ChangeNotifier{
  String uid = UserDao().auth.currentUser?.uid as String;
  String name = "";
  String address = "";
  String phone = "";
  String email = "";


    @override
  Future<void> init() async {
    Map<String, dynamic> user = await UserApi.getUserInformation(uid);
    print(user);
    print("USER");
    print(user['data']);
    user = user['data'];
    print("test here");
    name = user['name'] as String;
    if(user['address'] != null){
      address = user['address'];
    }
    print("step 2");
    email = user['email'] as String;
    phone = user['phone'] as String;
    print("data here");
    print(name);
    print(this.email);
    notifyListeners();

  }

  @override
  String getAddress() => address;

  @override
  String getName() => name;

  @override
  String getPhone() => phone;

    @override
  String getEmail() => email;

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

  void setAllData(String address, String name){
    this.address = address;
    this.name = name;
    print("where is it");
    UserApi.updateUser(uid, name, address);
    notifyListeners();
  }




}