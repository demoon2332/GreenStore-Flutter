import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  String? pid;
  int? price;
  String? title;
  String? url;
  String? country;
  String? brand;
  String? category_sn;
  String? details;
  double? discount;

  Product({this.pid, this.price, this.title, this.url,
    this.country, this.brand, this.category_sn, this.details, this.discount});

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson()=> _$ProductToJson(this);

}