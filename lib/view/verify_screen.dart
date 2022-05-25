import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './constant_value.dart';
import 'name_screen.dart';

enum Status { Waiting, Error,Done }

class VerifyScreen extends StatefulWidget{
  final phoneNumber;
  const VerifyScreen({Key? key, this.phoneNumber}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VerifyScreenState();
  }

}

class _VerifyScreenState extends State<VerifyScreen>{
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final otpController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  var _verificationId;
  late int resendingToken;
  var _status = Status.Waiting;
  String error = "";

  @override
  void initState(){
    super.initState();
    _verifyPhoneNumber(-1);
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future _verifyPhoneNumber(int resendingToken) async {
    if(resendingToken == -1){
      try{
        await _auth.verifyPhoneNumber(phoneNumber: widget.phoneNumber,
            timeout: const Duration(seconds: 90),
            verificationCompleted: (phonesAuthCredentials) async {},
            verificationFailed: (verificationFailed) async {},
            codeSent: (verificationId,resendingToken) async {
              setState(() {
                _verificationId = verificationId;
                resendingToken = resendingToken;
              });
            },
            codeAutoRetrievalTimeout: (verificationId) async {});
      }
      on FirebaseAuthException catch(e){
        setState(() {
          print("firebase error in verifyPhone ");
          error = e.message!;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
        });
      }
      catch (e) {
        setState(() {
          print("Error sms in func verifyPhonenumber");
          print(e.toString());
          error = "Something went wrong, we can't verify your sms code. Please try again.";
          error = e.toString();
        });
      }
    }
    else{
      try{
        await _auth.verifyPhoneNumber(phoneNumber: widget.phoneNumber,
            timeout: const Duration(seconds: 90),
            forceResendingToken: resendingToken,
            verificationCompleted: (phonesAuthCredentials) async {},
            verificationFailed: (verificationFailed) async {},
            codeSent: (verificationId,resendingToken) async {
              setState(() {
                _verificationId = verificationId;
                resendingToken = resendingToken;
              });
            },
            codeAutoRetrievalTimeout: (verificationId) async {});
      }
      on FirebaseAuthException catch(e){
        setState(() {
          print("firebase error in verifyPhone ");
          error = e.message!;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
        });
      }
      catch (e) {
        setState(() {
          print("Error sms in func verifyPhonenumber");
          print(e.toString());
          error = "Something went wrong, we can't verify your sms code. Please try again.";
          error = e.toString();
        });
      }
    }

  }

  Future _sendCode({String ? code}) async {
    // print("get inside sendcode");
    if (_verificationId != null) {
      var credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: otpController.text);

      await _auth
          .signInWithCredential(credential)
          .then((value) {
        Navigator.push(context,
        MaterialPageRoute(builder: (context)=> NameScreen()));
      })
          .whenComplete(() {})
          .onError((error, stackTrace) {
        setState(() {
          otpController.text = "";
          _status = Status.Error;
        });
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Center(
          child: Text('Verify Phone Number'),
        ),
      ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(child: otpField())
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: verifyButton(context),
                      )
                    ],
                  ),
                  Center(
                    child: Text(error,style: TextStyle(color: errorColor),),
                  )
                ],
              ),
            ),
          ),
        ) //
    );
  }

  Widget otpField() {
    return TextFormField(
      controller: otpController,
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        border: UnderlineInputBorder(),
        labelText: 'SMS Code ',
        hintText: 'Enter SMS code',
      ),
      autocorrect: false,
      autofocus: false,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.phone,
      validator: (value) => phoneValidator(value!),
    );
  }

  Widget verifyButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          print("otp: " + otpController.text);
          _sendCode();
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (_) => HomeScreen()));
        },
        child: const Padding(
          padding: EdgeInsets.all(6),
          child: Text('Continue'),
        ));
  }
}

  String? phoneValidator(String phone) {
        if(phone.isEmpty){
      return 'Phone is required.';
    }
    if(phone.length < 6){
      return 'Phone number must longer than 5 digits.';
    }
    else if(int.tryParse(phone)==null){
      return "Phone shouldn't contain letter or any special characters.";
    }
    else{
      return null;
    }
  }