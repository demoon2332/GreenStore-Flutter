import 'package:intl/intl.dart';

class PriceConvert{
  static String convertToVnd(int price){
    var formatter = NumberFormat.decimalPattern('vi-VN');
    return formatter.format(price)+" đ";
  }

}