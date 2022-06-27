import 'package:flutter/material.dart';

import '../../convert/price_convert.dart';

import '../../models/product.dart';
import '../../repository/MemFavRepos.dart';
import 'package:provider/provider.dart';

import '../items/no_items_page.dart';

class FavoriteScreenWithAppbar extends StatefulWidget {
  const FavoriteScreenWithAppbar({Key? key}) : super(key: key);

  @override
  State<FavoriteScreenWithAppbar> createState() => _FavoriteScreenWithAppbarState();
}

class _FavoriteScreenWithAppbarState extends State<FavoriteScreenWithAppbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Favorite Screen',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(
            color: Colors.green,
          ),
        ),
        body: SafeArea(
          child: Container(
            padding:
            const EdgeInsets.only(top: 36, bottom: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Favorite",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Slide to remove product.",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    SizedBox(height: 22),
                  ],
                ),
                Expanded(
                  child: showData(context),
                  flex: 4,
                ),
              ],
            ),
          ),
        ));
  }

  //TODO: Add Dismissible to delete items
  Widget showData(BuildContext context) {
    return Consumer<MemFavRepos>(
      builder: (context, memFavRepos, child) {
        if(memFavRepos.getLength() > 0){
          return ListView.builder(
            itemCount: memFavRepos.getLength(),
            itemBuilder: (context, index) {
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  memFavRepos.deleteProduct(index);
                },
                background: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.delete, color: Colors.white, size: 32),
                  ),
                ),
                child: buildItemSearch(
                    context, memFavRepos.getProductByPosition(index)),
              );
            },
          );
        }
        else{
          return NoItemsPage.buildNoProductPage();
        }
      },
    );
  }

  Widget buildItemSearch(BuildContext context, Product _product) {
    const urlPrimary = 'https://greenstore-api.herokuapp.com/';
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, 'p_details',arguments: _product.pid);
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
                          padding: EdgeInsets.only(left: 10, right: 10, top: 8),
                          child: Text(
                            _product.title!,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              PriceConvert.convertToVnd(_product.price!),
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
}

