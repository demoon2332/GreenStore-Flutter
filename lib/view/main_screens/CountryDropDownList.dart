import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../constant_value.dart';
import '../../convert/short_title.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry ({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelectCountryState();
  }
}
class _SelectCountryState extends State<SelectCountry> {
  List<dynamic>? jsonData;
  String? _myState;
  List<dynamic>? data; // display on screen

  @override
  void initState(){
    _getData();
    super.initState();
  }

  Future _getData() async {
    final String response =
    await rootBundle.loadString('assets/country_code.json');
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
                  value: _myState,
                  iconSize: 30,
                  icon: (null),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  hint: Text(
                    'Select Country',),
                  onChanged: (String? newValue) {
                    setState(() {
                      _myState = newValue;
                      print(_myState);
                    });
                  },
                  items: data?.map((item) {
                    return new DropdownMenuItem(
                        child: new Text(ShortTitle.sortTitle(item['name']) ),
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
        borderRadius: BorderRadius.circular(18),
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