import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class OrderApi{
  static const url_link = 'https://greenstore-api.herokuapp.com/order/';

  Future<List<dynamic>?> getAllOrders(String uid) async{
    var response = await http.get(Uri.parse(url_link+uid));
    var jsonObject = json.decode(response.body);
    if(jsonObject['code']==0){
      if(jsonObject['data'].length==0){
        return null;
      }
      return jsonObject['data'];
    }
    return null;
  }

  Future<Map<String, dynamic>?> getOrderDetail(String uid, String oid) async{
    var response = await http.get(Uri.parse(url_link+uid+'/'+oid));
    var jsonObject = json.decode(response.body);
    if(jsonObject['code']==0){
      if(jsonObject['data'].length==0){
        return null;
      }
      return jsonObject['data'][0];
    }
    return null;
  }

}