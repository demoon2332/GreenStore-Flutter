// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserFromJson(Map<String, dynamic> json) => UserInfo(
  uid: json['pid'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  address: json['address'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$UserToJson(UserInfo instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'address': instance.address,
  'createdAt': instance.createdAt,
};
