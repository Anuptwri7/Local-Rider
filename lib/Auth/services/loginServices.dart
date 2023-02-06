import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../Helpers/stringConst.dart';
import '../../Pages/homePage.dart';

class LoginServices{
  Future login(BuildContext context,String email,String password) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String,String> headers = {
      'Content-Type': 'multipart/form-data',
      // 'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
    };

    Map<String,String> msg = {
      'email': email,
      'password':password

      // "ownerPhoto":filename
    };
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(ApiConstant.baseUrl + ApiConstant.riderLogin),
    );
    log("kdsjhfldkj"+msg.toString());
    request.headers.addAll(headers);
    request.fields.addAll(msg);
    // request.files.add(
    //   http.MultipartFile.fromBytes(
    //     "ownerPhoto",
    //     File(imageFile.path).readAsBytesSync(),
    //     filename: imageFile.path,
    //   ),
    // );
    request.send().then((response) {
      log("jlkj"+response.statusCode.toString());
      log("kj"+response.reasonPhrase.toString());
      try {
        if (response.statusCode == 200||response.statusCode==201) {
          Fluttertoast.showToast(msg: "Logged in Successfully");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
          return const Text("data");
          // return const Text ("");
        }else{
          Fluttertoast.showToast(msg: "Error");
        }
      } catch (e) {

        throw Exception(e);
      }
    });
  }
}
