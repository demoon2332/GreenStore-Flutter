import 'package:greenstore_flutter/view/phoneAuthentication/edit_phone_number.dart';

import './view/screen_export.dart';
class Routes{
  static final routes = {
    'splash_screen': (context) => const SplashScreen(),
    '/': (context) => const MainPage(),
    'login': (context) => const LoginPage(),
    'register': (context) => const RegisterPage(),
    'home': (context) => const HomeScreen(),
    'search': (context) => const SearchScreen(),
    'cate': (context)=> const CategoryScreen(),
    'fav': (context) => const FavoriteScreen(),
    'cart': (context) => const CartScreen(),
    'cate_items': (context) => const CategoryItemsScreen(),
    'p_details': (context) => const ProductDetailScreen(),
    'ratings': (context) => const RatingScreen(),
    'c_order': (context) => const ConfirmOrderScreen(),
    's_order': (context) => const OrderSucessfulScreen(),
    'his_order': (context) => const OrderHistoryListScreen(),
    'd_order': (context) => const OrderDetailScreen(),
    'user_profile': (context) => const UserProfileScreen(),
    'cart_screen_w_appbar': (context) => const CartScreenWithAppBar(),
    'fav_scr_w_appbar': (context) => const FavoriteScreenWithAppbar(),

  };
}