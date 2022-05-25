import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'constant_value.dart';
import 'verify_screen.dart';
import 'select_countries.dart';

class EditPhoneScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditPhoneScreenState();
  }

}

class EditPhoneScreenState extends State<EditPhoneScreen>{

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  // default phone format for Vietnam phone number
  Map<String, dynamic> data = {"name": "Vietnam", "code": "+84"};
  Map<String, dynamic>? dataResult;

  @override

    Widget build(BuildContext context) {
 
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Center(
              child: Text('Zalo Login'),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
                child: Center(
                  child: Column(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Text(
                            data['code'],
                            style:
                            TextStyle(fontSize: 16.sp, color: primaryColor),
                          ),
                          Expanded(child: phoneField()),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text(
                              "Click here to change country code",
                              style: TextStyle(
                                  color: primaryColor, fontSize: 14.0.sp)),
                          onPressed: () async {
                            dataResult = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SelectCountry()));
                            setState(() {
                              if (dataResult != null) data = dataResult!;
                            });
                          },
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: loginButton(context),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                  )
            ),
          ) //body
      );
    }
  Widget phoneField() {
    return TextFormField(
      controller: phoneController,
      decoration: InputDecoration(
        icon: Icon(Icons.phone),
        label: const Text(
          'Phone',
          style: TextStyle(color: Colors.grey),
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(12)),
        hintText: 'Enter phone number',
      ),
      autocorrect: false,
      autofocus: false,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.phone,
      validator: (value) => phoneValidator(value!),
    );
  }

  Widget loginButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: successColor,
            shape: StadiumBorder()),

        onPressed: () {
          print("Phone: " + phoneController.text);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => VerifyScreen(
                phoneNumber: data['code']! + phoneController.text,
              )));
        },
        child: const Padding(
          padding: EdgeInsets.all(6),
          child: Text(
            'Continue',
          ),
        ));
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