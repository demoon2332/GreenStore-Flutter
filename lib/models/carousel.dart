import 'package:json_annotation/json_annotation.dart';

part 'carousel.g.dart';

@JsonSerializable()
class Carousel{
  String? nextUrl;
  String? imgUrl;

  Carousel({this.nextUrl, this.imgUrl});

  factory Carousel.fromJson(Map<String, dynamic> json)=> _$CarouselFromJson(json);

  Map<String, dynamic> toJson()=> _$CarouselToJson(this);

}