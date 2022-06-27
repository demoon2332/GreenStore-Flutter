import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

import '../../convert/price_convert.dart';

import '../../models/product.dart';
import '../../services/product_api.dart';

class UserRating extends StatefulWidget {
  const UserRating({Key? key}) : super(key: key);

  @override
  State<UserRating> createState() => _UserRatingState();
}

class _UserRatingState extends State<UserRating> {
  @override
  Widget build(BuildContext context) {
    //final pid = ModalRoute.of(context)!.settings.arguments as String;
    final pid = "10";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rating',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: ListView(
              children: [
                buildItemSearch(context, pid),
              ],
            ),
          ),
          const SizedBox(height: 8),
          buildRatingButton(context, pid),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  Widget buildItemSearch(BuildContext context, String pid) {
    const urlPrimary = 'https://greenstore-api.herokuapp.com/';
    return FutureBuilder<dynamic>(
        future: ProductApi.getProductDetails(pid),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              //print(snapshot.data['data']);
              Product _product = Product.fromJson(snapshot.data['data']);
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'p_details',
                      arguments: pid);
                },
                child: SizedBox(
                  //width: 200,
                  height: 135,
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Image.network(urlPrimary + _product.url!,
                                  width: 150, height: 125),
                              fit: BoxFit.fill,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 8),
                                    child: Text(
                                      _product.title!,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Padding(
                                      padding:
                                      EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        PriceConvert.convertToVnd(
                                            _product.price!),
                                        style: const TextStyle(
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
                ),
              );
            }
            else{
              return Container();
            }
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            return Container();
          }
        });
  }

  Widget buildRatingButton(BuildContext context, String pid) {
    return InkWell(
      onTap: () {
        //TODO: Navigate ratings
        //Navigator.pushNamed(context, 'ratings',arguments: pid);
      },
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: Colors.green,
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: const Center(
              child: Text(
                'SUBMIT',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
              )),
        ),
      ),
    );
  }
}

