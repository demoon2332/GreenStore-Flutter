import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@JsonSerializable()
class Rating {
  String? pid;
  String? cus_id;
  String? cus_name;
  int? star;

  Rating({this.pid, this.cus_id, this.cus_name, this.star});

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
