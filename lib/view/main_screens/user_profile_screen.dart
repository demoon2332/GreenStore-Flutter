import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../repository/MemUserInfoRepos.dart';
import '../../services/user_api.dart';

//model
import '../../models/DAO/user_dao.dart';
import '../../models/user.dart' as UserModel;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String uid = UserDao().auth.currentUser?.uid as String;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    var memUserInfoRepos = Provider.of<MemUserInfoRepos>(context, listen: false);
    _initLoading(memUserInfoRepos);
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'My Account',
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: const IconThemeData(
              color: Colors.green,
            ),
            actions: [
              InkWell(
                  onTap: () {
                    _submitResult(memUserInfoRepos);
                  },
                  child: const Icon(Icons.done))
            ],
          ),
          body: Container(padding: const EdgeInsets.all(16), child: buildBody()),
        ),
      );
  }

  void _initLoading(MemUserInfoRepos memUserInfoRepos) {
    if(!isInit){
      _nameController.text = memUserInfoRepos.getName();
      _addressController.text = memUserInfoRepos.getAddress();
      _phoneController.text = memUserInfoRepos.getPhone();
      isInit = true;
    }
  }

  Widget buildBody() {
    return ListView(
      children: [
        buildForm(),
      ],
    );
  }

  Widget buildForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      child: Form(
          key: _formKey,
          child: Column(children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
            ),
              FutureBuilder(
                future: UserApi.getUserInformation(uid),
                builder: (BuildContext context,
                    AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      var data = snapshot.data['data'];
                      UserModel.UserInfo user = UserModel.UserInfo.fromJson(data);
                      print("user information");
                      print(user.email);
                      print(user.phone);
                      print(user.name);
                      print(user.address);
                      return Column(
                        children: [
                          avatar(),
                          contact(user.email!, user.phone!),
                          nameField(user.name),
                          const SizedBox(
                            height: 20,
                          ),
                          addressField(user.address),
                          const SizedBox(
                            height: 20,
                          ),
                          Divider(color: Colors.grey[300], thickness: 6),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      );
                    } else {
                      return Image.asset('assets/not_found.jpg');
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/not_found.jpg'),
                              Text('Something went wrong while loading'),
                            ],
                          ), //child:
                    );
                  }
                }),
          ])),
    );
  }

  Widget buildTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }

  Widget avatar() {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/ava.png'),
            )
          ],
        ),
      ],
    );
  }

  Widget contact(String email,String phone){
    return Row(
      children: [
        Padding(padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
          child: Center(
            child: Text("ductrong1313@gmail.com"+email),
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
          child: Center(
            child: Text("0909459110"+phone),
          ),
        )
      ],
    );
  }


  Widget addressField(String? address) {
    return TextFormField(
      validator: (value) => addressValidator(value!),
      controller: _addressController,
      decoration: InputDecoration(
          hintText: address,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16))),
    );
  }

  Widget nameField(String? name) {
    return TextFormField(
      validator: (value) => nameValidator(value!),
      controller: _nameController,
      decoration: InputDecoration(
          hintText: name,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16))),
    );
  }

  Widget phoneField(String? phone) {
    return TextFormField(
      validator: (value) => phoneValidator(value!),
      controller: _phoneController,
      decoration: InputDecoration(
          hintText: phone,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16))),
    );
  }

  void _submitResult(MemUserInfoRepos memUserInfoRepos) {
    if (_formKey.currentState!.validate()) {
      memUserInfoRepos.setAllData(_addressController.text, _nameController.text, _phoneController.text);
      UserApi.updateUser(uid,_nameController.text, _addressController.text);
      Navigator.pop(context);
    }
  }

  String? phoneValidator(String value) {
    if (value == null || value.isEmpty) {
      return "Enter phone number";
    } else if (!RegExp("[0-9]").hasMatch(value)) {
      return "It's not phone format";
    }
    return null;
  }

  String? nameValidator(String value) {
    if (value == null || value.isEmpty) {
      return "Enter your name";
    } else if (RegExp("[0-9]").hasMatch(value)) {
      return "Wrong name format";
    }
    return null;
  }

  String? addressValidator(String value) {
    if (value == null || value.isEmpty) {
      return "Enter your name";
    }
    return null;
  }
}
