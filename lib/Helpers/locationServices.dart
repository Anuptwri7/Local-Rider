import 'dart:developer';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
    final String key= "AIzaSyDjTJsc1uhHKEeaRl7I_xvuT4sDR9vDf6E";

      Future<String> getPlaceId(String input)async{
        final String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";
      var response =await http.get(Uri.parse(url));

      var json = convert.jsonDecode(response.body);


      var placeId = json['candidates'][0]['place_id'] as String;


      return placeId;
      }

      Future<Map<String,dynamic>> getPlace(String input) async{
        final placeId = await getPlaceId(input);
        final String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key";

        var response =await http.get(Uri.parse(url));

        var json = convert.jsonDecode(response.body);

        var result = json['result'] as Map<String,dynamic>;
        log("edwrefrwe"+result.toString());
        return result;
      }

      Future<Map<String,dynamic>> getDirection(String origin,String destination) async{

        final String url = "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key";

        var response =await http.get(Uri.parse(url));
        var json = convert.jsonDecode(response.body);
        var result = {
          'bounds_ne':json['routes'][0]['bounds']['northeast'],
          'bounds_sw':json['routes'][0]['bounds']['southwest'],
          'start_location':json['routes'][0]['legs'][0]['start_location'],
          'end_location':json['routes'][0]['legs'][0]['end_location'],
          'polyline':json['routes'][0]['overview_polyline']['points'],
          'polyline_decoded':PolylinePoints().decodePolyline(json['routes'][0]['overview_polyline']['points']),
        };
        return result;
      }



    Future<Map<String,dynamic>> getPlaceDest(String input) async{
      // final placeId = await getPlaceId(input);
      final String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$input&key=$key";

      var response =await http.get(Uri.parse(url));

      var json = convert.jsonDecode(response.body);

      var result = json['result'] as Map<String,dynamic>;
      log("edwrefrwe"+result.toString());
      return result;
    }

    Future<Map<String,dynamic>> getPlaceOrg(String input) async{
      // final placeId = await getPlaceId(input);
      final String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$input&key=$key";

      var response =await http.get(Uri.parse(url));

      var json = convert.jsonDecode(response.body);

      var result = json['result'] as Map<String,dynamic>;
      log("edwrefrwe"+result.toString());
      return result;
    }






}