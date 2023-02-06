import 'dart:developer';
import 'dart:io' show Platform, stdout;
import 'package:flutter/material.dart';

import 'Auth/Login/lognRiderPage.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
     MyApp(),
  );
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Soori RFID',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home:  LoginScreen(toggle: false,),
    );
  }
}


