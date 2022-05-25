import '../models/product_ordered.dart';
import 'price_convert.dart';
class GetTotalOrder{
  static String getTotalOrder(List<ProductOrdered> p){
    int sum = 0;
    for (var element in p) {
      sum+= element.price!* element.quantity!;
    }
    return PriceConvert.convertToVnd(sum);
  }
}