import 'dart:convert';
import 'package:http/http.dart' as http;

class RatingsApi{
  static const url_link = 'https://greenstore-api.herokuapp.com/rating/';

  static Future<Map<String, dynamic>> getRatings(String pid) async{
    var response = await http.get(Uri.parse(url_link+pid));
    var jsonObject = json.decode(response.body);
    return jsonObject;
  }
}