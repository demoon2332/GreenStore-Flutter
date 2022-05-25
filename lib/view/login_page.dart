import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/DAO/user_dao.dart';
import 'edit_phone_number.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(1.1, 0.0),
          colors: <Color>[Color(0xb434eb00), const Color(0xffffffff)],
          tileMode: TileMode.repeated,
        )),
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ListView(shrinkWrap: true, children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 24,
              shadowColor: Colors.green,
              child: Column(children: [
                const SizedBox(height: 16),
                const Text(
                  'Đăng nhập',
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

  Widget buildForm(BuildContext context, UserDao userDao) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 8),
            btnSubmit(context, userDao),
            const SizedBox(height: 12),
            const Text(
              "Hoặc",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            btnPhoneLogin(),
            const SizedBox(height: 12),
            const Text(
              "Chưa có tài khoản? ",
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
          label: const Text(
            'Email',
            style: TextStyle(color: Colors.green),
          ),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
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
          label: const Text(
            'Mật khẩu',
            style: const TextStyle(color: Colors.green),
          ),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16))),
    );
  }

  Widget btnSubmit(BuildContext context, UserDao userDao) {
    return SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          child: const Text(
            "ĐĂNG NHẬP",
            style: TextStyle(fontSize: 14),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.green),
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
          child: const Text(
            "ĐĂNG KÝ NGAY",
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.yellow),
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
            padding: const EdgeInsets.all(8),
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
                side: const BorderSide(color: Colors.green),
              ))),
          onPressed: () {},
        ));
  }

  Widget btnPhoneLogin(){
    return SizedBox(
        height: 40,
        width: double.infinity,
        child: ElevatedButton(
          child: Padding(
            padding: const EdgeInsets.all(8),
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
                side: const BorderSide(color: Colors.green),
              ))),
          onPressed: () {
            Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPhoneScreen())
                    );
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

    String? passwordValidator(String? pass){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if(regExp.hasMatch(pass!))
      return "At least 1 uppercase, lowercase and a special character.";
    else
      return null;
    //   return "Password must be longer than 8 and include"
    //   +"\n At least 1 uppercase character"
    // +"\n At least 1 lowercase character"
    // +"\n At least 1 special character.";
  }


}
