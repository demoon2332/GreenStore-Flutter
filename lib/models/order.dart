import 'package:json_annotation/json_annotation.dart';
import './product_ordered.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  String? oid;
  String? cus_id;
  List<ProductOrdered>? items;

  Order({this.oid, this.cus_id, this.items});

  factory Order.fromJson(Map<String,dynamic> json) => _$OrderFromJson(json);

  Map<String,dynamic> toJson()=> _$OrderToJson(this);

}