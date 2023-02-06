import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var textBoxDecoration = BoxDecoration(
    color: Colors.white,
    // border:Border.all(color:Color(0xff2C51A4).withOpacity(0.8) ) ,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.grey,
        spreadRadius: 1,
        blurRadius: 2,
        offset: Offset(4, 4),
      )
    ]);

var bookingDecoration = BoxDecoration(

  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(15.0),
    topRight: Radius.circular(15.0),

  ),
    color: Colors.red.shade100
);

var hintStyle = TextStyle(
  fontSize: 14,
  color: Colors.black,
);
var appBarTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,

);
