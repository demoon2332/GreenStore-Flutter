import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:async/async.dart';
import 'package:greenstore_flutter/view/constant_value.dart';
import 'dart:convert';

//STATE MANAGEMENT
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletons/skeletons.dart';
import '../../navigation/MainPageNav.dart';

// MODELS
import '../../models/export_models.dart';

//SERVICES
import '../../services/carousel_api.dart';
import '../../services/category_items_api.dart';

//ITEMS
import '../items/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const urlPrimary = 'https://greenstore-api.herokuapp.com/';
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    var _tabPage = Provider.of<MainPageNav>(context, listen: false);
    return Scaffold(
      backgroundColor: successColorLight,
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          primary: true,
          scrollDirection: Axis.vertical,
          children: [
            headingTitleCard(_tabPage),
            const SizedBox(height: 16),
            buildCarousel(),
            buildOverviewCategory("Meat", "Fresh meat and seafood", "meat"),
            buildOverviewCategory(
                "Meat", "Plenty of spices and sauces", "spice-sauce"),
            buildOverviewCategory(
                "Snack", "Popular snack, cookies, or chips", "snack"),
            buildOverviewCategory(
                "Drinks", "Different kind of drinks", "drink"),
            buildOverviewCategory(
                "Vegetables", "Many types of fresh vegetables", "veg"),
            buildOverviewCategory("Noodles", "Common noodles", "noodles"),
          ],
        ),
      )),
    );
  }

  Widget headingTitleCard(var _tabPage) {
    return Container(
        padding: const EdgeInsets.only(top: 24, bottom: 16, left: 4, right: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "GreenStore",
                  style: TextStyle(
                      color: yellow,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(1, 1),
                            blurRadius: 8),
                      ],
                      fontSize: 30.sp),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'user_profile');
                  },
                  child: CircleAvatar(
                    backgroundImage: const AssetImage('assets/u_avatar2.png'),
                    backgroundColor: Colors.green[300],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: successColor,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    alignment: Alignment.center,
                    //OPEN DRAWER
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Expanded(
                  child: TextField(
                    onTap: () {
                      _tabPage.changeTab(1);
                    },
                    keyboardType: TextInputType.none,
                    autofocus: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.search, color: Colors.green),
                      hintText: 'Search something...',
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }

  Widget buildCarousel() {
    return FutureBuilder(
        future: CarouselApi.getAllCarousel(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var _data = snapshot.data['data'];
            return CarouselSlider.builder(
              itemCount: _data.length,
              options: CarouselOptions(
                height: 150,
                autoPlay: true,
              ),
              itemBuilder: (BuildContext context, int index, int pageIndex) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        print('--> page ' + index.toString());
                        //TODO: Add Navigator from _data[index]['next_url']
                        Navigator.of(context).pushNamed('cate_items',
                            arguments: _data[index]['next_url'].split('/')[2]);
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: FittedBox(
                              child: Image.network(
                                  urlPrimary + _data[index]['url']),
                              fit: BoxFit.fill,
                            ),
                          )),
                    );
                  },
                );
              },
            
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CarouselSlider.builder(
              itemCount: 4, 
              options:  CarouselOptions(
                height: 150,
                autoPlay: true,
              ),
              itemBuilder: (BuildContext context, int index, int pageIndex) {
                return SkeletonItem(
                child: SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: 90.w,
              minHeight: MediaQuery.of(context).size.height / 8,
              maxHeight: MediaQuery.of(context).size.height / 3,
            ),
            )
            );
              },
            
              );
          } else {
            return const Text('Something went wrong while loading Carousel');
          }
        });
  }

  Widget buildOverviewCategory(
      String headerText, String title, String shortCate) {
    return SizedBox(
      height: 50.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //TODO: Change to dynamic header
              Text(
                headerText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                        color: strongGray.withOpacity(0.5),
                        offset: const Offset(1, 1),
                        blurRadius: 8),
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {
                    //TODO: Add Navigator.push -> Material Page
                    Navigator.of(context)
                        .pushNamed('cate_items', arguments: shortCate);
                  },
                  child: Row(
                    children: [
                      Text(
                        "More",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 15.sp,
                            color: contentColorLightTheme),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.green),
                    ],
                  )),
            ],
          ),
          //TODO: Change to dynamic title
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              color: contentColorLightTheme,
              shadows: [
                Shadow(
                    color: strongGray.withOpacity(0.5),
                    offset: const Offset(1, 1),
                    blurRadius: 8),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // buildProductCard(),
          //Expanded(child:demoLV()),
          Expanded(child: buildProductCard(shortCate)),
        ],
      ),
    );
  }

  //TODO: Limit product's title length is 30.
  Widget buildProductCard(String shortCate) {
    //TODO: Add ListView.builder -> Future.builder
    return FutureBuilder(
        future: CategoryItemsApi.getProductsByCategory(shortCate),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var data = snapshot.data['data'];
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    Product product = Product.fromJson(data[index]);

                    return ProductCard.getProductCard(context, product);
                  });
            } else {
              return const Center(child: Text('No data'));
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Text('Something went wrong while loading');
          }
        });
  }
}
