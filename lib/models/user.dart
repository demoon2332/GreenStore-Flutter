import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserInfo {
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? createdAt;


  UserInfo({this.uid, this.name, this.email, this.phone,
    this.address, this.createdAt});

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson()=> _$UserToJson(this);

}