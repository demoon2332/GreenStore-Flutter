import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
//DAO
import '../models/DAO/user_dao.dart';

import 'package:provider/provider.dart';

import '../routes.dart';
import '../navigation/MainPageNav.dart';

import '../repository/MemFavRepos.dart';
import '../repository/MemCartRepos.dart';
import '../repository/MemUserInfoRepos.dart';

class MyApp extends StatelessWidget {
  const MyApp ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return Sizer(
      builder: (context,orientation,deviceType){
        return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDao> (lazy: false,
          create: (_)=> UserDao(),
        ),
        ChangeNotifierProvider(
          create: (_)=> MainPageNav(),
        ),
        ChangeNotifierProvider(
          create: (_)=> MemFavRepos(),
        ),
        ChangeNotifierProvider(
          create: (_)=> MemCartRepos(),
        ),
        ChangeNotifierProvider(
          create: (_)=> MemUserInfoRepos(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Colors.white,
          ),
        ),
        routes: Routes.routes,
        initialRoute: 'splash_screen',
      ),
    );
      }
    );
  }
}
