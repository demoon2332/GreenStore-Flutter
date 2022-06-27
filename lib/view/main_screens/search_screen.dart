import 'package:flutter/material.dart';
import 'package:greenstore_flutter/view/constant_value.dart';

import '../../services/product_api.dart';
import '../../models/export_models.dart';
import '../../convert/price_convert.dart';
import '../../convert/short_title.dart';

//shared references
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _searchFocusNode = FocusNode();
  String _searchText = "";

  @override
  void initState(){
    super.initState();
  }

  void getHistory () async{
    SharedPreferences local = await SharedPreferences.getInstance();
    var historySearch = local.getString('history-search');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: successColorLight,
          body: SafeArea(child: 
          GestureDetector(
            onTap: (){
              _searchFocusNode.unfocus();
            },
            child: Container(
        padding: EdgeInsets.only(top: 36, bottom: 16, left: 16, right: 16),
        child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Search",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  const SizedBox(height: 16),
                  buildSearchField(),
                  const SizedBox(height: 16),
                ],
              ),
              Expanded(
                child: showData(),
                flex: 4,
              ),
            ],
        ),
      ),
          ))  
 );
  }

  Widget buildSearchField() {
    return TextField(
      keyboardType: TextInputType.text,
      onChanged: (data) {
        startSearch(data);
      },
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
          suffixIcon: Icon(Icons.search, color: Colors.green),
          hintText: 'Search something...',
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16))),
    );
  }

  //TODO: ADD Future Builder and ListView.builder when user start texting. (Check if text is null, clear the showData)
  Widget showData() {
    if (_searchText.length < 1) {
      return notFoundScreen();
    } else {
      return FutureBuilder(
          future: ProductApi.searchProduct(_searchText),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var code = snapshot.data['code'];
                if (code == 0) {
                  var dt = snapshot.data['data'];
                  return ListView.builder(
                    itemCount: dt.length,
                    itemBuilder: (context, index) {
                      Product product = Product.fromJson(dt[index]);
                      return buildItemSearch(product);
                    },
                    primary: true,
                  );
                } else {
                  return notFoundScreen();
                }
              }
              return notFoundScreen();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Text('Something went wrong while searching');
            }
          });
    }
  }

  Widget notFoundScreen() {
    return Image.asset('assets/not_found.jpg');
  }

  void startSearch(String res) {
    setState(() {
      _searchText = res;
    });
  }

  Widget buildItemSearch(Product product) {
    return SizedBox(
        //width: 200,
        height: 125,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'p_details', arguments: product.pid!);
          },
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Image.network(
                          'https://greenstore-api.herokuapp.com/' +
                              product.url!,
                          width: 150,
                          height: 110),
                      fit: BoxFit.fill,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 8),
                            child: Text(
                              ShortTitle.sortTitle(product.title!),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                PriceConvert.convertToVnd(product.price!),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 20),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
