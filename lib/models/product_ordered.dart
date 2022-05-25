import 'package:json_annotation/json_annotation.dart';

part 'product_ordered.g.dart';

@JsonSerializable()
class ProductOrdered{
  String? pid;
  int? price;
  String? title;
  String? url;
  int? quantity;

  ProductOrdered({this.pid, this.price, this.title, this.url, this.quantity});

  factory ProductOrdered.fromJson(Map<String, dynamic> json) => _$ProductOrderedFromJson(json);

  Map<String, dynamic> toJson()=> _$ProductOrderedToJson(this);

}