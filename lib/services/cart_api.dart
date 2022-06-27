import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//MODELS

class CartApi{
  static const url_link = 'https://greenstore-api.herokuapp.com/cart/';

  //NOTE: uid comes from userDAO in providers
  //get only items atrtribute
  Future<List<dynamic>?> getCart(String uid) async{
    var response = await http.get(Uri.parse(url_link+uid));
    var jsonObject = json.decode(response.body);
    if(jsonObject['code']==0){
      //print(jsonObject);
      if(jsonObject['data'][0]['items'].length ==0){
        return null;
      }
      return jsonObject['data'][0]['items'];
    }
    else{
      return null;
    }
  }

  Future<void> increaseItemQuantityBy1(String uid, String pid) async{
    var response = await http.post(Uri.parse(url_link+uid+'/'+pid));
    //var jsonObject = json.decode(response.body);
    return Future.value();
  }

  Future<void> decreaseItemQuantityBy1(String uid, String pid) async{
    var response = await http.put(Uri.parse(url_link+uid+'/'+pid));
    //var jsonObject = json.decode(response.body);
    return Future.value();
  }

  Future<void> deleteItem(String uid, String pid) async{
    var response = await http.delete(Uri.parse(url_link+uid+'/'+pid));
    //var jsonObject = json.decode(response.body);
    return Future.value();
  }

  Future<void> startOrder(String uid) async{
    const url_link = 'https://greenstore-api.herokuapp.com/order/';
    var response = await http.post(Uri.parse(url_link+uid));
    //var jsonObject = json.decode(response.body);
    return Future.value();
  }

}