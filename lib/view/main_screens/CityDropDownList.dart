import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../constant_value.dart';

class SelectCity extends StatefulWidget {
  const SelectCity ({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelectCityState();
  }
}
class _SelectCityState extends State<SelectCity> {
  List<dynamic>? jsonData;
  String? _myCity;
  List<dynamic>? data; // display on screen
  @override
  void initState(){
    _getData();
    super.initState();
  }

  Future _getData() async {
    final String response =
    await rootBundle.loadString('assets/local.json');
    jsonData = await json.decode(response) as List<dynamic>;
    setState(() {
      data = jsonData;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height*0.08,
      width: size.width*0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(20),
                  value: _myCity,
                  iconSize: 30,
                  icon: (null),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  hint: Text(
                    'Select City',),
                  onChanged: (String? newValue) {
                    setState(() {
                      _myCity = newValue;
                      print(_myCity);
                    });
                  },
                  items: data?.map((item) {
                    return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['name'].toString()
                    );
                  })?.toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border:  Border.all(
          color: strongGray,
          style: BorderStyle.solid,
          width: 1.0,

        ),
      ),
      );


  }



}