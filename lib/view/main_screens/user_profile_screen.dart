import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../repository/MemUserInfoRepos.dart';
import '../../services/user_api.dart';

//model
import '../../models/DAO/user_dao.dart';
import '../../models/user.dart' as UserModel;

//responsive
import 'package:sizer/sizer.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late MemUserInfoRepos user;

  String uid = UserDao().auth.currentUser?.uid as String;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  late Future<dynamic> getUserInfo;

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  bool isInit = false;
  String _error = "";

  @override
  void initState() {
    super.initState();
    user = Provider.of<MemUserInfoRepos>(context, listen: false);
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    user = Provider.of<MemUserInfoRepos>(context, listen: false);
    getUserInfo = user.init().then((value){
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _addressController.text = user.address;
    }).onError((error, stackTrace) => null);
  }

  @override
  Widget build(BuildContext context) {
    _initLoading(user);
    return buildForm2(context);
    
  }

  void _initLoading(MemUserInfoRepos memUserInfoRepos) {
    if (!isInit) {
      setState(() {
        _emailController.text = memUserInfoRepos.getEmail();
        _nameController.text = memUserInfoRepos.getName();
        _addressController.text = memUserInfoRepos.getAddress();
        _phoneController.text = memUserInfoRepos.getPhone();
      });
      isInit = true;
    }
  }

  void update(){
    print("user to get");
    print(user.getEmail());
    print(user.getAddress());
    print(user.getName());
    _emailController.text = user.getEmail();
    _nameController.text = user.getName();
    _addressController.text = user.getAddress();
    _phoneController.text = user.getPhone();
  }

  Widget buildBody() {
    return ListView(
      children: [
        buildForm2(context),
      ],
    );
  }

  Widget buildForm2(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.green,
          ),
          actions: [
            InkWell(
                onTap: () {
                  _submitResult(user);
                },
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 8, 2),
                  child: Icon(Icons.done),
                ))
          ],
        ),
        body: SafeArea(child: 
        Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 250.0,
                    color: Colors.white,
                    child: FutureBuilder(
                        future: getUserInfo,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Column(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 20.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.account_circle,
                                          color: Colors.black,
                                          size: 22.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 25.0),
                                          child: Text('PROFILE',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                  fontFamily:
                                                      'sans-serif-light',
                                                  color: Colors.black)),
                                        )
                                      ],
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Stack(
                                      fit: StackFit.loose,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                                width: 140.0,
                                                height: 140.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: ExactAssetImage(
                                                        'assets/ava.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 90.0, right: 100.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  radius: 25.0,
                                                  child: Icon(
                                                    Icons.camera_alt,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            )),
                                      ]),
                                )
                              ],
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                    //                 FutureBuilder(
                    // future: getUserInfo,
                    // builder:
                    //     (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    //   if (snapshot.connectionState == ConnectionState.done) {
                  ),
                  Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Parsonal Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status ? _getEditIcon() : Container(),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),
                                      enabled: !_status,
                                      autofocus: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Email',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                          hintText: "Modify email"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      controller: _phoneController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        'City',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        'Address',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            hintText: "Enter your city"),
                                        enabled: !_status,
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: TextField(
                                      controller: _addressController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter your full address"),
                                      enabled: !_status,
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Center(
                            child: Text(
                              _error,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          !_status ? _getActionButtons() : Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ))
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
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 6),
                  child: Text(
                    "Your Information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                )),
            FutureBuilder(
                future: getUserInfo,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        avatar(),
                        contact(user.getEmail(), user.getPhone()),
                        SizedBox(
                          height: 2.h,
                        ),
                        nameField(user.getName()),
                        SizedBox(
                          height: 2.h,
                        ),
                        addressField(user.getAddress()),
                        Divider(color: Colors.grey[300], thickness: 6),
                      ],
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        const Center(child: CircularProgressIndicator())
                      ],
                    );
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
        SizedBox(width: 10.w),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }

  Widget avatar() {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(4),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage('assets/ava.png'),
      ),
    ));
  }

  Widget contact(String email, String phone) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
          child: Center(
            child: Text("Email: " + email),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
          child: Center(
            child: Text("Phone: " + phone),
          ),
        )
      ],
    );
  }

  Widget addressField(String address) {
    // _addressController.text = address;
    return TextFormField(
      validator: (value) => addressValidator(value!),
      controller: _addressController,
      decoration: InputDecoration(
          label: Text("Address"),
          hintText: address,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16))),
    );
  }

  Widget nameField(String name) {
    // _nameController.text = name;
    return TextFormField(
      validator: (value) => nameValidator(value!),
      controller: _nameController,
      decoration: InputDecoration(
          label: Text("Name"),
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
    _phoneController.text = phone!;
    return TextFormField(
      validator: (value) => phoneValidator(value!),
      controller: _phoneController,
      decoration: InputDecoration(
          hintText: "Enter your phone number",
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16))),
    );
  }

  void _submitResult(MemUserInfoRepos memUserInfoRepos) {
    if (addressValidator(_addressController.text) == null &&
        nameValidator(_nameController.text) == null) {
      memUserInfoRepos.setAllData(
          _addressController.text, _nameController.text);
      //UserApi.updateUser(uid, _nameController.text, _addressController.text);
    } else {
      setState(() {
        if(addressValidator(_addressController.text) != null){
          _error = _error + "${addressValidator(_addressController.text)} \n";
        }
        if(nameValidator(_nameController.text) != null){
          _error = _error + "${nameValidator(_nameController.text)} \n";
        }
      });
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
      return "Please enter address";
    }
    return null;
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _submitResult(user);
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
