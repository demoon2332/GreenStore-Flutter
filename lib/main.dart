import 'package:flutter/material.dart';
import './view/myapp.dart';
import 'package:firebase_core/firebase_core.dart';



//import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}


