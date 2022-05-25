// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      pid: json['pid'] as String?,
      price: json['price'] as int?,
      title: json['title'] as String?,
      url: json['url'] as String?,
      country: json['country'] as String?,
      brand: json['brand'] as String?,
      category_sn: json['category_sn'] as String?,
      details: json['details'] as String?,
      on_sale: json['on_sale'] as bool?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'pid': instance.pid,
      'price': instance.price,
      'title': instance.title,
      'url': instance.url,
      'country': instance.country,
      'brand': instance.brand,
      'category_sn': instance.category_sn,
      'details': instance.details,
      'on_sale': instance.on_sale,
    };
