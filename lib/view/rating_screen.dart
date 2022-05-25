import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../convert/avg_ratings.dart';
import '../models/rating.dart';

import '../services/ratings api.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    final pid = ModalRoute.of(context)!.settings.arguments as String;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Đánh giá chi tiết',
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: const IconThemeData(
              color: Colors.green,
            ),
          ),
          body: Container(
            padding:
                const EdgeInsets.only(top: 36, bottom: 16, left: 16, right: 16),
            child: FutureBuilder(
                future: RatingsApi.getRatings(pid),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      var data = snapshot.data['data'];
                      if (data.length > 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            overallRating(data),
                            const SizedBox(
                              height: 16,
                            ),
                            Divider(color: Colors.grey[300], thickness: 1.5),
                            Expanded(child: buildComments(data)),
                          ],
                        );
                      } else {
                        return const Center(
                            child: Text('Sản phẩm này chưa có bài đánh giá nào.'));
                      }
                    } else {
                      return const Center(child: Text('Không có dữ liệu'));
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(child: Text('Lỗi khi tải dữ liệu'));
                  }
                }),
          )),
    );
  }

  List<Rating> getsample() {
    late List<Rating> data = [];
    var js = [
      {
        "_id": "62707c9facc580bc3d728aec",
        "pid": "1",
        "cus_id": "112334",
        "cus_name": "Lê Văn An",
        "star": 4,
        "__v": 0
      },
      {
        "_id": "62707c9facc580bc3d728aed",
        "pid": "1",
        "cus_id": "116532",
        "cus_name": "Nguyễn Thị Bảy",
        "star": 5,
        "__v": 0
      }
    ];
    js.forEach((element) {
      data.add(Rating.fromJson(element));
    });
    return data;
  }

  Widget buildComments(List<dynamic> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        Rating rating = Rating.fromJson(data[index]);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height:16),
            Row(children: [
              Expanded(
                  child:
                  Text(rating.cus_name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  flex: 3),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.topRight,
                  child: RatingBar.builder(
                    initialRating: rating.star!.toDouble(),
                    itemSize: 18,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            Text("Sản phẩm tốt", style: TextStyle(fontSize: 18, color: Colors.grey[700]),),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[300], thickness: 1.5),
          ],
        );
      },
    );
  }

  Widget overallRating(List<dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: AvgRatings.getAvgRatingsFromJson(data),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                          color: Colors.black),
                    ),
                    const WidgetSpan(
                      child: Icon(Icons.star, color: Colors.yellow, size: 48),
                    )
                  ])),
                ],
              ),
            ),
            Expanded(
                child: Text(
              data.length.toString() + " đánh giá",
              style: TextStyle(fontSize: 24, color: Colors.grey[700]),
            )),
          ],
        ),
      ],
    );
  }
}
