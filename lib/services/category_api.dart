import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryApi{
  static const url_link = 'https://cryptic-caverns-40086.herokuapp.com/category';

  static Future<Map<String,dynamic>> getAllCategories ()async{
    var response = await http.get(Uri.parse(url_link));
    var jsonObject = json.decode(response.body);
    return jsonObject;
  }
}