// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_ordered.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOrdered _$ProductOrderedFromJson(Map<String, dynamic> json) =>
    ProductOrdered(
      pid: json['pid'] as String?,
      price: json['price'] as int?,
      title: json['title'] as String?,
      url: json['url'] as String?,
      quantity: json['quantity'] as int?,
    );

Map<String, dynamic> _$ProductOrderedToJson(ProductOrdered instance) =>
    <String, dynamic>{
      'pid': instance.pid,
      'price': instance.price,
      'title': instance.title,
      'url': instance.url,
      'quantity': instance.quantity,
    };
