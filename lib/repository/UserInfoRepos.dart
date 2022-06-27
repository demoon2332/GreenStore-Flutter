
import '../models/user.dart';

abstract class UserInfoRepos{
  String getName();
  String getPhone();
  String getAddress();
  String getEmail();


  void setName(String name);
  void setAddress(String address);
  void setAllData(String address, String name);
  Future<void> init();
}