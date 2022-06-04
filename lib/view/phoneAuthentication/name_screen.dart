import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/user_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constant_value.dart';
import 'package:sizer/sizer.dart';
import '../main_page.dart';
import '../constant_value.dart';


class NameScreen extends StatefulWidget {
  const NameScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NameScreenState();
  }
}

class NameScreenState extends State<StatefulWidget> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String _error = "";
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void storeUserToFirestore(){
    users
      .where('uid',isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get()
        .then(
        (QuerySnapshot snapshot){
          print("snapshot");
          print(snapshot);
            if(snapshot.docs.isEmpty){
              users.add({
                'name': nameController.text,
                'phone': FirebaseAuth.instance.currentUser?.phoneNumber,
                'status': 'Available',
                'uid': FirebaseAuth.instance.currentUser?.uid
              });
            }
    },

    ).catchError((error){_error = error.toString();print("Error in nameScreen:"+error);});
  }

  Future<Map<String, dynamic>> storeUserToAPI() async {
    var json = await UserApi.signUp(nameController.text, FirebaseAuth.instance.currentUser?.uid, " ", FirebaseAuth.instance.currentUser?.phoneNumber);
    return json;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Naming'),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
            child: Form(
              key: _formKey,
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:  MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:  MainAxisAlignment.start,
                      children: [
                        nameField(),
                        Padding(
                          padding: EdgeInsets.only(left: 8,right: 0,top: 4,bottom: 0),
                          child: Text("Example: Name_Birth",style: TextStyle(color: strongGray,fontSize: 14.0.sp),),
                        )
                      ],
                    )),

                    Expanded(
                      flex: 2,
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:  [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 8,right: 0,top: 0,bottom: 0),
                          child: Text('• Please do not violence.',style: TextStyle(fontSize: 14.0.sp),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8,right: 5,top: 6,bottom: 0),
                          child: Text('• A friendly name is recommended.',style: TextStyle(fontSize: 14.0.sp),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8,right: 5,top: 6,bottom: 0),
                          child: Text('• You can change it later.',style: TextStyle(fontSize: 14.0.sp),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8,right: 5,top: 6,bottom: 0),
                          child: Text('• A friendly name is recommended.',style: TextStyle(fontSize: 14.0.sp),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8,right: 5,top: 6,bottom: 0),
                          child: Text('• The name will be updated if you have already logged before.',style: TextStyle(fontSize: 14.0.sp),),
                        ),
                      ],
                    ))
                  ],
                ),
              )
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try{
            FirebaseAuth.instance.currentUser?.updateDisplayName(nameController.text);
            //storeUserToFirestore();
            var json = await storeUserToAPI();
            if(json['code'] == 0){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: successColorLight,
                content: Text("Announcement: ${json['message'].toString()} "),
              ));
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: errorColorLight,
                content: Text("Announcement: ${json['message'].toString()} "),
              ));
            }
            Navigator.popAndPushNamed(context,'home');
          }
          catch(error){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: errorColorLight,
              content: Text("Register fail: "+error.toString()),
            ));
          }

        },
    child: const Icon(Icons.arrow_right_alt_sharp),
    )//body
    );
  }

  Widget nameField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0,horizontal: 8),
      child: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          label: const Text(
            'Your name',

          ),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: successColor),
              borderRadius: BorderRadius.circular(16)),
          hintText: 'Enter your name',
        ),
        autocorrect: false,
        autofocus: false,
        textCapitalization: TextCapitalization.none,
        keyboardType: TextInputType.name,
        validator: (value)=> nameValidator(value!),
      ),
    );
  }

  Widget registerButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if(_formKey.currentState!.validate()){
            FirebaseAuth.instance.currentUser?.updateDisplayName(nameController.text);
            //storeUserToFirestore();
            storeUserToAPI();

            Navigator.popAndPushNamed(context,'home');
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Register fail\nError: "+_error),
            ));
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(6),
          child: Text('Continue'),
        ));
  }
}

  String? nameValidator(String phone) {
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