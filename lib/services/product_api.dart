import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductApi{
  static const url_link = 'https://greenstore-api.herokuapp.com/products/';

  static Future<Map<String, dynamic>> getProductDetails(String pid) async{
    var response = await http.get(Uri.parse(url_link+pid));
    var jsonObject = json.decode(response.body);
    return jsonObject;
  }

  static Future<Map<String, dynamic>> searchProduct(String title) async{
    var response = await http.get(Uri.parse(url_link+'search/'+title));
    var jsonObject = json.decode(response.body);
    print("fetch search successfully");
    print(jsonObject);
    return jsonObject;
  }

}