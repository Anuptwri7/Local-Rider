import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../Helpers/stringConst.dart';
import '../../Pages/homePage.dart';
import '../Login/lognRiderPage.dart';

class RegisterServices{
  Future RegisterUser(BuildContext context,String name,String email,String password,String phone) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String,String> headers = {
      'Content-Type': 'multipart/form-data',
      // 'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
    };

    Map<String,String> msg = {
      'name':name,
      'email': email,
      'password':password,
      'phone':phone

      // "ownerPhoto":filename
    };
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(ApiConstant.baseUrl + ApiConstant.regUser),
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
          Fluttertoast.showToast(msg: "Registered Successfully");
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
