import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/DAO/user_dao.dart';
import 'phoneAuthentication/edit_phone_number.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorAfterSubmit = "";

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  checkLogin() async {
    var a = await auth.currentUser;
    if (a != null) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScrollController _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
    return Scaffold(
        body: SafeArea(
          child: Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  reverse: true,
                  controller: _scrollController,
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/login.png',
                            fit: BoxFit.fill,
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              width: size.width * 0.9,
                              decoration: BoxDecoration(),
                              child: Column(
                                children: [FormLogin()],
                              )),
                        ]),
                  ),
                ))
          ],
        ),
      
        )
      );
  }

  Widget FormLogin() {
    final _userDao = Provider.of<UserDao>(context, listen: false);
    return Column(
      children: [
        Column(
          children: [
            buildForm(context, _userDao),
            btnSubmit(context, _userDao),
            SizedBox(height: 8),
            btnPhoneLogin(),
            SizedBox(height: 8),
            btnRegister(),
            SizedBox(height: 8),
          ],
        )
      ],
    );
  }

  Widget buildForm(BuildContext context, UserDao userDao) {
    return Container(
      child: Form(
          key: _formKey,
          child: Column(children: [
            emailField(),
            SizedBox(height: 16),
            passwordField(),
            Text(
              _errorAfterSubmit,
              style: TextStyle(color: Colors.red),
            ),
          ])),
    );
  }

  Widget emailField() {
    return TextFormField(
      validator: (value) => emailValidator(value!),
      controller: _emailController,
      decoration: InputDecoration(
          hintText: 'Enter your email',
          label: Text(
            'Email',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16))),
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      validator: (value) => passwordValidator(value!),
      controller: _passwordController,
      decoration: InputDecoration(
          hintText: 'Enter your password',
          label: Text(
            'Password',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16))),
    );
  }

  Widget btnSubmit(BuildContext context, UserDao userDao) {
    return SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          child: Text(
            "LOGIN",
            style: TextStyle(fontSize: 14),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.green),
              ))),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              //TODO: Check Email and Password
              String _result = await userDao.login(
                  _emailController.text, _passwordController.text);
              if (await userDao.isLoggedIn()) {
                Navigator.pushReplacementNamed(context, '/');
              } else {
                setState(() {
                  _errorAfterSubmit = _result;
                });
              }
            }
          },
        ));
  }

  Widget btnRegister() {
    return SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          child: Text(
            "REGISTER",
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.yellow),
              ))),
          onPressed: () {
            Navigator.pushNamed(context, 'register');
          },
        ));
  }

  Widget btnGoogleLogin() {
    return SizedBox(
        height: 40,
        width: double.infinity,
        child: ElevatedButton(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: FittedBox(
                fit: BoxFit.fill,
                alignment: Alignment.center,
                child:
                    Image.asset('assets/gg_icon.png', height: 40, width: 60)),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.green),
              ))),
          onPressed: () {},
        ));
  }

  Widget btnPhoneLogin() {
    return SizedBox(
        height: 40,
        width: double.infinity,
        child: ElevatedButton(
          child: Text(
            "LOGIN WITH PHONE NUMBER",
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.green),
              ))),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditPhoneScreen()));
          },
        ));
  }

  String? emailValidator(String value) {
    if (value == null || value.isEmpty) {
      return "Enter your email";
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Invalid email";
    }
    return null;
  }

  String? passwordValidator(String? pass) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (regExp.hasMatch(pass!))
      return "At least 1 uppercase, lowercase and a special character.";
    else
      return null;
    //   return "Password must be longer than 8 and include"
    //   +"\n At least 1 uppercase character"
    // +"\n At least 1 lowercase character"
    // +"\n At least 1 special character.";
  }
}
