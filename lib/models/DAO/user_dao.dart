import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../services/user_api.dart';

class UserDao extends ChangeNotifier{
  final auth = FirebaseAuth.instance;
  var _verificationId;
  late int resendingToken;
  String _name = "";
  String _address ="";
  String _phone = "";
  String _email = "";

  


  Future<bool> isLoggedIn(){
    return Future.value(auth.currentUser !=null);
  }

  String? userId(){
    return auth.currentUser?.uid;
  }

  String? email(){
    if(auth.currentUser?.email != "")
      return auth.currentUser?.email;
    else
      return _email;
  }

  String? name(){
      return _name;
  }

  String? address(){
    return _address;
  }

  String? phone(){
    if(auth.currentUser?.phoneNumber != "")
      return auth.currentUser?.phoneNumber;
    else
      return _phone;
  }

  void setEmail(String email){
    _email = email;
    notifyListeners();
  }

  void setName(String name){
    _name = name;
    print("set name in user dao");
    print(_name);
    notifyListeners();
  }

  void setAddress(String address){
    _address = address;
    notifyListeners();
  }

  void setPhone(String phone){
    _phone = phone;
    notifyListeners();
  }




  //SIGN UP
  Future<String> signup(String email, String password) async{
    try{
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      var result = await UserApi.signUp("Guest",auth.currentUser?.uid,auth.currentUser?.email , auth.currentUser?.phoneNumber);
      if(result['code']==0){
        await auth.signOut();
        notifyListeners();
        return "";
      }

    } on FirebaseAuthException catch (e){
      if(e.code == 'weak-password'){
        return "Weak password";
      }
      else if(e.code == 'email-already-in-use'){
        return "Email already-in-use";
      }
    }
    catch(e){
      print(e);
    }
    return "Error when registering";
  }

  // SIGN IN
  Future<String> login(String email, String password) async{
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return "";
    }
    on FirebaseAuthException catch (e){
      print(e.code);
      print("E code of firebaseAuthException");
      if(e.code == 'weak-password'){
        return "Weak password";
      }
      else if (e.code == 'wrong-password') {
        return "Wrong password";
      }
    }
    catch(e){
      print(e);
    }
    return "Login fail";
  }

  Future<String> loginWithPhone(String phone) async {
    try{
        await auth.verifyPhoneNumber(phoneNumber: phone,
            timeout: const Duration(seconds: 90),
            forceResendingToken: resendingToken,
            verificationCompleted: (phonesAuthCredentials) async {},
            verificationFailed: (verificationFailed) async {},
            codeSent: (verificationId,resendingToken) async {            
              _verificationId = verificationId;
              resendingToken = resendingToken;
            },
            codeAutoRetrievalTimeout: (verificationId) async {});
      }
      on FirebaseAuthException catch(e){
          print("firebase error in verifyPhone ");
          return e.message!;
      }
      catch (e) {

          print("Error sms in func verifyPhonenumber");
          print(e.toString());
          return "Something went wrong, we can't verify your sms code. Please try again.";

      }
      return "Something went wrong, we can't verify your sms code. Please try again.";
  }

  //LOG OUT
  void logout() async{
    await auth.signOut();
    notifyListeners();
  }

}