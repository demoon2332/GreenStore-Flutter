import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/DAO/user_dao.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorAfterSubmit = "";

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userDao = Provider.of<UserDao>(context, listen: false);

    return SafeArea(
        child: Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        //color: Colors.purple,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(1.1, 0.0),
          colors: <Color>[Color(0xb434eb00), Color(0xffffffff)],
          tileMode: TileMode.repeated,
        )),
        padding: EdgeInsets.all(32),
        child: Center(
          child: ListView(shrinkWrap: true, children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 24,
              shadowColor: Colors.green,
              child: Column(children: [
                const SizedBox(height: 16),
                Text(
                  'Đăng ký',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                buildForm(context, _userDao),
              ]),
            ),
          ]),
        ),
      ),
    ));
  }

  Widget buildForm(BuildContext context, UserDao _userDao) {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      child: Form(
          key: _formKey,
          child: Column(children: [
            emailField(),
            const SizedBox(height: 16),
            passwordField(),
            const SizedBox(height: 12),
            Text(
              _errorAfterSubmit,
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 8),
            btnSubmit(context, _userDao),
            const SizedBox(height: 24),
            const Text(
              "Đã có tài khoản? ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            btnRegister(),
            const SizedBox(height: 8),
          ])),
    );
  }

  Widget emailField() {
    return TextFormField(
      validator: (value) => emailValidator(value!),
      controller: _emailController,
      decoration: InputDecoration(
          hintText: 'Vui lòng nhập email của bạn',
          label: Text(
            'Email',
            style: TextStyle(color: Colors.green),
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
          hintText: 'Vui lòng nhập mật khẩu của bạn',
          label: Text(
            'Mật khẩu',
            style: TextStyle(color: Colors.green),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16))),
    );
  }

  Widget btnSubmit(BuildContext context, UserDao _userDao) {
    return SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          child: Text(
            "ĐĂNG KÝ",
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
            //TODO: Check Email and Password
            if (_formKey.currentState!.validate()) {
              String _result = await _userDao.signup(
                  _emailController.text, _passwordController.text);
              if (_result == "") {
                Navigator.pop(context);
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
            "ĐĂNG NHẬP NGAY",
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
            Navigator.pop(context);
          },
        ));
  }

  String? emailValidator(String value) {
    if (value == null || value.isEmpty) {
      return "Vui lòng điền email";
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Sai định dạng email";
    }
    return null;
  }

  String? passwordValidator(String password) {
    if (password == null || password.isEmpty) {
      return "Vui lòng điền password";
    } else if (password.length < 6) {
      return "Mật khẩu tối thiểu từ 6 ký tự trở lên";
    }
    return null;
  }
}
