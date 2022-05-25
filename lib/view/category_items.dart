import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/category_items_api.dart';
import './items/product_card.dart';

class CategoryItemsScreen extends StatefulWidget {
  const CategoryItemsScreen({Key? key}) : super(key: key);

  @override
  State<CategoryItemsScreen> createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
  @override
  Widget build(BuildContext context) {
    //PASS ARGUMENTS
    final cateArgs = ModalRoute.of(context)!.settings.arguments as String;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(cateArgs, style: TextStyle(color: Colors.black),),
          iconTheme: const IconThemeData(
            color: Colors.green,
          ),
        ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder(
              future: CategoryItemsApi.getProductsByCategory(cateArgs),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasData){
                    var data = snapshot.data['data'];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        const SizedBox(height: 12),
                        const Text(
                          "Danh sách tìm kiếm",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.6)),
                          itemCount: data.length,
                          primary: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index){
                            Product product = Product.fromJson(data[index]);
                            return ProductCard.getProductCard(context, product);
                          },
                        ),
                      ),]
                    );
                  }
                  else{
                    return const Center(child: Text('Không có dữ liệu'));
                  }
                }
                else if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
                else{
                  return const Center(child: Text('Đã có lỗi khi tải dữ liệu'));
                }

              }
            ),
          )),
    );;
  }
}
