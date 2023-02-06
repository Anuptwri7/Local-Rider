import 'dart:convert';
import 'dart:developer';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Helpers/stringConst.dart';

Future saveCurrentLocation(double lat, double lng) async {

  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();


  final response = await http.post(
      Uri.parse(ApiConstant.baseUrl +  ApiConstant.currentLocation ),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
      },
      body: json.encode({
        "current_lat": lat,
        "current_lng": lng,
      }));
log(response.statusCode.toString());
log(response.body.toString());
log("$lat+$lng");
  try {
    if (response.statusCode == 200) {

      return response.body;
    }else{
      log(response.statusCode.toString());
    }
  } catch (e) {
    throw Exception(e);
  }
}