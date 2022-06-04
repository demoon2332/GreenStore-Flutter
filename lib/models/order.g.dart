// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      oid: json['oid'] as String?,
      cus_id: json['cus_id'] as String?,
      createdAt: json['createdAt'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ProductOrdered.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'oid': instance.oid,
      'cus_id': instance.cus_id,
      'items': instance.items,
      'createdAt': instance.createdAt
    };
