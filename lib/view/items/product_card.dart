import 'package:flutter/material.dart';
import 'package:greenstore_flutter/view/constant_value.dart';
import '../../models/export_models.dart';
//CONVERT
import '../../convert/price_convert.dart';
import '../../convert/short_title.dart';

//responsive
import 'package:sizer/sizer.dart';

class ProductCard {
  static const urlPrimary = 'https://greenstore-api.herokuapp.com/';

  static Widget getProductCard(BuildContext context, Product product) {
    String price = PriceConvert.convertToVnd(product.price!);
    if (product.discount != null) {
      if (product.discount! > 0) {
        price = PriceConvert.convertToVnd(
            (product.price! - product.price! * product.discount!).round());
      }
    }
    return GestureDetector(
      onTap: () {
        //TODO: Add navigator.push -> product.pid
        Navigator.pushNamed(context, 'p_details', arguments: product.pid);
      },
      child: SizedBox(
        width: 40.w,
        height: 40.h,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2), // if you need this
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  urlPrimary + product.url!,
                  // width: 40.w,
                  // height: 30.h,
                  fit: BoxFit.cover,
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      price,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 18),
                    )),
              Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 8, bottom: 5),
                    child: Text(ShortTitle.sortTitle(product.title!))),
            ],
          ),
        ),
      ),
    );
  }
}
