import 'package:flutter/material.dart';
import 'package:greenstore_flutter/view/constant_value.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

//SPECIFIC SCREEN
import '../models/DAO/user_dao.dart';
import 'main_screens/home_screen.dart';
import 'main_screens/search_screen.dart';
import './category/category_screen.dart';
import 'main_screens/favorite_screen.dart';
import 'main_screens/cart_screen.dart';

//NAV
import '../navigation/MainPageNav.dart';

import '../repository/MemFavRepos.dart';
import '../repository/MemCartRepos.dart';

//responsive
import 'package:sizer/sizer.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> pageList = <Widget>[];

  @override
  void initState() {
    // TODO: implement initState
    pageList.add(const HomeScreen());
    pageList.add(const SearchScreen());
    pageList.add(const CategoryScreen());
    pageList.add(const FavoriteScreen());
    pageList.add(const CartScreen());
    super.initState();
  }

  void drawerPop(int index, MainPageNav tabPage) {
    tabPage.changeTab(index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //var tabPage = Provider.of<MainPageNav>(context, listen: true);
    var _userDao = Provider.of<UserDao>(context, listen: false);
    return Consumer3<MainPageNav, MemFavRepos, MemCartRepos>(
      builder: (context, mainPageNav, memFavRepos, memCartRepos, children) {
        int tabPage = mainPageNav.getPageIndex();
        return Scaffold(
          backgroundColor: successColorLight,
          drawer: Drawer(
            child: ListView(
              //physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              primary: false,
              shrinkWrap: false,
              children: [
                DrawerHeader(
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    //TODO 1: Add username from repository
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your list',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: ListTile(
                              title: const Text('Home'),
                              leading:
                              const Icon(Icons.home, color: Colors.green),
                              contentPadding: const EdgeInsets.only(left: 0.0),
                              onTap: () => drawerPop(0, mainPageNav),
                              //
                            ),
                          ),
                          Expanded(
                              child: ListTile(
                                title: const Text('Favorite'),
                                leading: const Icon(Icons.star,
                                    color: Color.fromARGB(255, 250, 182, 72)),
                                contentPadding: const EdgeInsets.only(left: 0.0),
                                onTap: () => drawerPop(3, mainPageNav),
                              )),
                        ]),
                  ),
                ),
                const Divider(color: Colors.grey),
                // CATEGORY
                ListTile(
                  title: const Text('Meat'),
                  leading:
                  const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  contentPadding: const EdgeInsets.only(left: 0.0),
                  //TODO: NAVIGATE
                  onTap: () => {
                    Navigator.pushNamed(context, 'cate_items', arguments: 'meat')
                  },
                ),
                ListTile(
                  title: const Text('Vegetables'),
                  leading:
                  const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  contentPadding: const EdgeInsets.only(left: 0.0),
                  //TODO: NAVIGATE
                  onTap: () => {
                    Navigator.pushNamed(context, 'cate_items', arguments: 'veg')
                  },
                ),
                ListTile(
                  title: const Text('Drinks'),
                  leading:
                  const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  contentPadding: const EdgeInsets.only(left: 0.0),
                  //TODO: NAVIGATE
                  onTap: () => {
                    Navigator.pushNamed(context, 'cate_items',
                        arguments: 'drink')
                  },
                ),
                ListTile(
                  title: const Text('Noodles'),
                  leading:
                  const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  contentPadding: const EdgeInsets.only(left: 0.0),
                  //TODO: NAVIGATE
                  onTap: () => {
                    Navigator.pushNamed(context, 'cate_items',
                        arguments: 'noodles')
                  },
                ),
                ListTile(
                  title: const Text('Snack'),
                  leading:
                  const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  contentPadding: const EdgeInsets.only(left: 0.0),
                  //TODO: NAVIGATE
                  onTap: () => {
                    Navigator.pushNamed(context, 'cate_items',
                        arguments: 'snack')
                  },
                ),
                ListTile(
                  title: const Text('Spice and Sauce'),
                  leading:
                  const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  contentPadding: const EdgeInsets.only(left: 0.0),
                  //TODO: NAVIGATE
                  onTap: () => {
                    Navigator.pushNamed(context, 'cate_items', arguments: 'spice-sauce')
                  },
                ),
                const Divider(color: Colors.grey),
                // CATEGORY
                ListTile(
                  title: const Text('My Account'),
                  leading:
                  const Icon(Icons.account_circle, color: Colors.green),
                  contentPadding: const EdgeInsets.only(left: 0.0),
                  //TODO: NAVIGATE
                  onTap: () {
                    Navigator.pushNamed(context, 'user_profile');
                  },
                ),
                ListTile(
                  title: const Text('My order'),
                  leading: const Icon(Icons.shopping_cart, color: Colors.green),
                  contentPadding: const EdgeInsets.only(left: 0.0),
                  //TODO: NAVIGATE
                  onTap: () => drawerPop(4, mainPageNav),
                ),
                ListTile(
                  title: const Text('History'),
                  leading: const Icon(Icons.bookmark_border_rounded,
                      color: Colors.green),
                  contentPadding: const EdgeInsets.only(left: 0.0),
                  //TODO: NAVIGATE
                  onTap: () {
                    Navigator.pushNamed(context, 'his_order');
                  },
                ),
                ListTile(
                  title: const Text('Log out'),
                  leading: const Icon(Icons.exit_to_app, color: Colors.red),
                  contentPadding: const EdgeInsets.only(left: 0.0),
                  //TODO: NAVIGATE
                  onTap: () {
                    _userDao.logout();
                    memFavRepos.close();
                    memCartRepos.close();
                    Navigator.pushReplacementNamed(context, 'splash_screen');
                  },
                ),
                //DEMO
                // ListTile(
                //   title: const Text('Demo'),
                //   leading: const Icon(Icons.bookmark_border_rounded,
                //       color: Colors.green),
                //   contentPadding: const EdgeInsets.only(left: 0.0),
                //   //TODO: NAVIGATE
                //   onTap: () {
                //     Navigator.pushNamed(context, 'user_rating');
                //   },
                // ),
              ],
            ),
          ),
          body: SafeArea(
            child: IndexedStack(
              children: pageList,
              index: tabPage,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                  icon: const Icon(Icons.home), label: 'Home'),
              const BottomNavigationBarItem(
                  icon: const Icon(Icons.search), label: 'Search'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Category'),
              BottomNavigationBarItem(
                  icon: Badge(
                      badgeColor: Colors.red,
                      badgeContent: Text(
                        memFavRepos.getLength().toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      showBadge: (memFavRepos.getLength() > 0),
                      child: const Icon(Icons.favorite)),
                  label: 'Favorite'),
              BottomNavigationBarItem(
                  icon: Badge(
                      badgeColor: Colors.red,
                      badgeContent: Text(
                        memCartRepos.getLength().toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      showBadge: (memCartRepos.getLength() > 0),
                      child: const Icon(Icons.shopping_cart)),
                  label: 'Cart'),
            ],
            selectedItemColor: Colors.green,
            onTap: (index) {
              mainPageNav.changeTab(index);
            }, //=>_onItemPageTapped(index, tabPage),
            currentIndex: tabPage,
            elevation: 8,
          ),
        );
      },
    );
  }
}
