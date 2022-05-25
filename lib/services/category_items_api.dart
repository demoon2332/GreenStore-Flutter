import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class CategoryItemsApi{
  static const url_link = 'https://cryptic-caverns-40086.herokuapp.com/category/';

  static Future<Map<String, dynamic>> getProductsByCategory(String cate) async{
    var response = await http.get(Uri.parse(url_link+cate));
    var jsonObject = json.decode(response.body);
    return jsonObject;
  }

}