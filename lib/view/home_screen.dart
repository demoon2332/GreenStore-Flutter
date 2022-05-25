import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:async/async.dart';
import 'dart:convert';

//STATE MANAGEMENT
import 'package:provider/provider.dart';
import '../navigation/MainPageNav.dart';

// MODELS
import '../models/export_models.dart';
import '../models/DAO/user_dao.dart';

//SERVICES
import '../services/carousel_api.dart';
import '../services/category_items_api.dart';

//ITEMS
import './items/product_card.dart';

//NAV:
import '../navigation/MainPageNav.dart';
import '../repository/MemFavRepos.dart';
import '../repository/MemCartRepos.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const urlPrimary ='https://cryptic-caverns-40086.herokuapp.com/';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    var _userDao = Provider.of<UserDao>(context,listen: false);
    var _tabPage = Provider.of<MainPageNav>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
          body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          primary: true,
          scrollDirection: Axis.vertical,
          children: [
            headingTitleCard(_tabPage),
            const SizedBox(height: 16),
            buildCarousel(),
            buildOverviewCategory("Đồ uống","Các loại đồ uống, nước giải khát","drink"),
            buildOverviewCategory("Rau củ quả", "Các loại rau, củ, quả","veg"),
            buildOverviewCategory("Mì và bún", "Các loại mì và bún phổ biến","noodles"),
            buildOverviewCategory("Snack", "Các loại snack,bim bim phổ biến","snack"),
          ],
        ),
      ),
      // drawer: Drawer(
      //         child: ListView(
      //           physics: const NeverScrollableScrollPhysics(),
      //           padding: const EdgeInsets.all(16),
      //           primary: false,
      //           shrinkWrap: false,
      //           children: [
      //             DrawerHeader(
      //               child: Container(
      //                 margin: const EdgeInsets.only(top: 16),
      //                 //TODO 1: Add username from repository
      //                 child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       const Text(
      //                         'Xin chào',
      //                         style: TextStyle(
      //                             fontSize: 24, fontWeight: FontWeight.bold),
      //                       ),
      //                       const SizedBox(height: 4),
      //                       Expanded(
      //                         child: ListTile(
      //                           title: const Text('Trang chủ'),
      //                           leading: const Icon(Icons.home, color: Colors.green),
      //                           contentPadding: const EdgeInsets.only(left: 0.0),
      //                           onTap: ()=>drawerPop(0, mainPageNav),
      //                           //
      //                         ),
      //                       ),
      //                       Expanded(
      //                           child: ListTile(
      //                             title: const Text('Yêu thích'),
      //                             leading: const Icon(Icons.favorite, color: Colors.red),
      //                             contentPadding: const EdgeInsets.only(left: 0.0),
      //                             onTap: ()=>drawerPop(3, mainPageNav),
      //                           )),
      //                     ]),
      //               ),
      //             ),
      //             const Divider(color: Colors.grey),
      //             // CATEGORY
      //             ListTile(
      //               title: const Text('Rau củ quả'),
      //               leading: const Icon(Icons.arrow_forward_ios, color: Colors.green),
      //               contentPadding: const EdgeInsets.only(left: 0.0),
      //               //TODO: NAVIGATE
      //               onTap: ()=> {
      //                 Navigator.pushNamed(context, 'cate_items', arguments: 'veg')
      //               },
      //             ),
      //             ListTile(
      //               title: const Text('Đồ uống'),
      //               leading: const Icon(Icons.arrow_forward_ios, color: Colors.green),
      //               contentPadding: const EdgeInsets.only(left: 0.0),
      //               //TODO: NAVIGATE
      //               onTap: ()=> {
      //                 Navigator.pushNamed(context, 'cate_items', arguments: 'drink')
      //               },
      //             ),
      //             ListTile(
      //               title: const Text('Mì và bún'),
      //               leading: const Icon(Icons.arrow_forward_ios, color: Colors.green),
      //               contentPadding: const EdgeInsets.only(left: 0.0),
      //               //TODO: NAVIGATE
      //               onTap: ()=> {
      //                 Navigator.pushNamed(context, 'cate_items', arguments: 'noodles')
      //               },
      //             ),
      //             ListTile(
      //               title: const Text('Snack'),
      //               leading: const Icon(Icons.arrow_forward_ios, color: Colors.green),
      //               contentPadding: const EdgeInsets.only(left: 0.0),
      //               //TODO: NAVIGATE
      //               onTap: ()=> {
      //                 Navigator.pushNamed(context, 'cate_items', arguments: 'snack')
      //               },
      //             ),
      //             const Divider(color: Colors.grey),
      //             // CATEGORY
      //             ListTile(
      //               title: const Text('Tài khoản của tôi'),
      //               leading: const Icon(Icons.account_circle, color: Colors.green),
      //               contentPadding: const EdgeInsets.only(left: 0.0),
      //               //TODO: NAVIGATE
      //               onTap: (){
      //                 Navigator.pushNamed(context, 'user_profile');
      //               },
      //             ),
      //             ListTile(
      //               title: const Text('Đơn hàng của tôi'),
      //               leading: const Icon(Icons.shopping_cart, color: Colors.green),
      //               contentPadding: const EdgeInsets.only(left: 0.0),
      //               //TODO: NAVIGATE
      //               onTap: ()=> drawerPop(4, mainPageNav),
      //             ),
      //             ListTile(
      //               title: const Text('Lịch sử đơn hàng'),
      //               leading: const Icon(Icons.bookmark_border_rounded, color: Colors.green),
      //               contentPadding: const EdgeInsets.only(left: 0.0),
      //               //TODO: NAVIGATE
      //               onTap: (){
      //                 Navigator.pushNamed(context, 'his_order');
      //               },
      //             ),
      //             ListTile(
      //               title: const Text('Đăng xuất'),
      //               leading: const Icon(Icons.exit_to_app, color: Colors.red),
      //               contentPadding: const EdgeInsets.only(left: 0.0),
      //               //TODO: NAVIGATE
      //               onTap: (){
      //                 _userDao.logout();
      //                 memFavRepos.close();
      //                 memCartRepos.close();
      //                 Navigator.pushReplacementNamed(context, 'splash_screen');
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      ),
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
                const Text(
                  "Home",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
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
                    color: Colors.grey[200],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.view_headline_sharp),
                    alignment: Alignment.center,
                    //OPEN DRAWER
                    onPressed: () {
                      //_scaffoldKey.currentState.openDrawer();
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
                      prefixIcon: const Icon(Icons.search, color: Colors.green),
                      hintText: 'Tìm kiếm mọi thứ tại đây',
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
        if(snapshot.connectionState == ConnectionState.done){
          var _data = snapshot.data['data'];
          return CarouselSlider.builder(
            itemCount: _data.length,
            options: CarouselOptions(
              height: 150,
              autoPlay: true,
            ),
            itemBuilder: (BuildContext context, int index, int pageIndex){
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: (){
                      print('--> page '+index.toString());
                      //TODO: Add Navigator from _data[index]['next_url']
                      Navigator.of(context).pushNamed('cate_items',arguments: _data[index]['next_url'].split('/')[2]);
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FittedBox(
                            child: Image.network(urlPrimary+_data[index]['url']),
                            fit: BoxFit.fill,
                          ),
                        )),
                  );
                },
              );
            },
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: const [
              CircularProgressIndicator(),
            ],
          );
        }
        else{
          return const Text('Đã có lỗi khi tải Carousel');
        }
      }
    );
  }

  Widget buildOverviewCategory(String headerText, String title, String shortCate) {
    return SizedBox(
      height: 325,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //TODO: Change to dynamic header
              Text(
                headerText,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              TextButton(
                onPressed: () {
                  //TODO: Add Navigator.push -> Material Page
                  Navigator.of(context).pushNamed('cate_items',arguments: shortCate);
                },
                child: const Icon(Icons.arrow_forward_ios, color: Colors.green),
              ),
            ],
          ),
          //TODO: Change to dynamic title
          Text(
            title,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            var data = snapshot.data['data'];
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index){
                Product product = Product.fromJson(data[index]);

                return ProductCard.getProductCard(context, product);
              }
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
          return const Text('Đã có lỗi khi tải dữ liệu');
        }

      }
    );
  }
}
