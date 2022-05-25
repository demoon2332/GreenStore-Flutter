

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constant_value.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry ({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelectCountryState();
  }


}

class _SelectCountryState extends State<SelectCountry> {
  List<dynamic>? jsonData;
  List<dynamic>? data; // display on screen
  TextEditingController _searchController = TextEditingController();
var searchValue = "";

  @override
  void initState(){
  _getData();
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Select Country"),
            backgroundColor: primaryColor,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  label: const Text(
                    'Country Code',
                    style: TextStyle(color: Colors.green),
                  ),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: successColor),
                      borderRadius: BorderRadius.circular(16)),
                  hintText: 'Search country code',
                ),
                onChanged: (value){
                  setState((){
                    searchValue = value;
                  });
                },
                controller: _searchController,
              ),
            )
          ),
          SliverList(
            delegate: SliverChildListDelegate((data) != null
                ? data!
                .where((e) => e['name']
                  .toString()
                  .toLowerCase()
                  .contains(searchValue.toLowerCase()))
                .map((e) => ListTile(
                title: Text(e['name']),
                trailing: Text(e['dial_code']),
              onTap: (){
                print(e['name']);
                Navigator.pop(context,{"name":e['name'],"code": e['dial_code']});
              },
            ))
            .toList()
  : [const Center(child: Text("Loading.."))]
            ),
          ),
        ],
      ),
    );
  }
}









































