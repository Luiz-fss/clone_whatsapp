import 'package:flutter/material.dart';
import 'package:whatsapp/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/RouteGenerator.dart';
import 'dart:io';
import 'Login.dart';

final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xff075E54),
    accentColor: Color(0xff25D366)
);

final ThemeData temaIOS = ThemeData(
    primaryColor: Colors.grey[200],
    accentColor: Color(0xff25D366)
);

void main (){
  runApp(MaterialApp(
    home: Login(),
    /*irá alterar a cor em muitos elementos de interface*/
    theme: Platform.isIOS ? temaIOS : temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));


}