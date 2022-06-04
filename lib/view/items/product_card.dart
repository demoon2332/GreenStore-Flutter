import 'package:flutter/material.dart';
import '../../models/export_models.dart';
//CONVERT
import '../../convert/price_convert.dart';
import '../../convert/short_title.dart';

class ProductCard{
  static const urlPrimary ='https://greenstore-api.herokuapp.com/';

  static Widget getProductCard(BuildContext context,Product product){
    return GestureDetector(
          onTap: (){
            //TODO: Add navigator.push -> product.pid
            Navigator.pushNamed(context,'p_details',arguments: product.pid);
          },
          child:SizedBox(
            width: 150,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Image.network(
                        urlPrimary+product.url!,
                        width: 150,
                        height: 150),
                    fit: BoxFit.fill,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        PriceConvert.convertToVnd(product.price!),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 18),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                      child: Text(ShortTitle.sortTitle(product.title!))),
                ],
              ),
            ),
          ),
      );

  }
}