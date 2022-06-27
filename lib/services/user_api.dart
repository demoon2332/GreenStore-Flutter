import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../repository/MemUserInfoRepos.dart';

class UserApi{
  static const urlLink = 'https://greenstore-api.herokuapp.com/user/';



  static Future<Map<String, dynamic>> signUp(String name,String? userId,String? email,String? phone) async{
    var url = Uri.parse(urlLink+"signup");
    var response = await http.post(url,body: {'name': name,'uid': userId,'email': email,'phone':phone});
    var jsonObject = json.decode(response.body);
    print('Response body:: ${response.body}');
    print("OBJECT");
    print(jsonObject);
    return jsonObject;
  }

  static Future<Map<String, dynamic>> updateUser(String uid,String? name,String? address) async{
    var url = Uri.parse(urlLink+"update");
    print("go hrere");
    var response = await http.post(url,body: {'uid': uid,'name': name,'address': address});
    var jsonObject = json.decode(response.body);

    print("user id"+uid);
    print("Update success");
    print('Response body--> ${response.body}');
    print("OBJECT");
    print(jsonObject);
    return jsonObject;
  }

  static Future<Map<String, dynamic>> getUserInformation(String uid) async{
    var response = await http.get(Uri.parse(urlLink+uid));
    var jsonObject = json.decode(response.body);
    print('Response body:: ${response.body}');
    print("OBJECT");
    print(jsonObject);
    return jsonObject;
  }

}









