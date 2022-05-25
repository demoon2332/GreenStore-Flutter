// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      pid: json['pid'] as String?,
      cus_id: json['cus_id'] as String?,
      cus_name: json['cus_name'] as String?,
      star: json['star'] as int?,
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'pid': instance.pid,
      'cus_id': instance.cus_id,
      'cus_name': instance.cus_name,
      'star': instance.star,
    };
