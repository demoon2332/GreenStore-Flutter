import '../models/export_models.dart';
import 'package:intl/intl.dart';

class AvgRatings{
  static String getAvgRatings(List<Rating> ratingList){
    if(ratingList.isEmpty || ratingList.length==0){
      return "0.0";
    }
    else{
      double avg = 0;
      ratingList.forEach((element) {
        avg += element.star!.toDouble();
      });
      avg /= ratingList.length;
      var formatter = NumberFormat.decimalPattern('vi-VN');
      print(formatter.format(avg));
      return formatter.format(avg)+"";
    }
  }

  static String getAvgRatingsFromJson(List<dynamic> ratingListJs){
    if(ratingListJs.isEmpty || ratingListJs.length==0){
      return "0,0";
    }
    else{
      List<Rating> ratingList = [];
      ratingListJs.forEach((e){
        ratingList.add(Rating.fromJson(e));
      });
      double avg = 0;
      ratingList.forEach((element) {
        avg += element.star!.toDouble();
      });
      avg /= ratingList.length;
      var formatter = NumberFormat('###.0','vi-VN');
      return formatter.format(avg)+"";
    }
  }

}