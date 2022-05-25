import 'package:async/async.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//models
import '../models/carousel.dart';

class CarouselApi {
  static const url_link = 'https://cryptic-caverns-40086.herokuapp.com/carousel';

  static Future<Map<String, dynamic>> getAllCarousel() async{
    var response = await http.get(Uri.parse(url_link));
    var jsonObject = json.decode(response.body);
    //print(jsonObject);
    return jsonObject;
  }
}