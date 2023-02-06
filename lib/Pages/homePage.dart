

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';

import '../Helpers/locationServices.dart';
import '../Helpers/styleConst.dart';
import '../services/currenLocation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocationService locationService = LocationService();
  TextEditingController _searchOriginController = TextEditingController();
  TextEditingController _searchDestinationController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController googleMapController ;
  static final Marker _kGooglePlexMarker = Marker(
    markerId: MarkerId("kGooglePlex"),
    infoWindow: InfoWindow(title: "Google Plex"),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    position: LatLng(27.7172, 85.3240),
  );

  static final Polyline _kPolyline = Polyline(
    polylineId: PolylineId('_kPolyline'),
    points: [
      LatLng(27.7172, 85.3240),
      LatLng(28.7171, 85.4242),
    ],
    width: 2,
  );
  String org='';
  String des='';
  double current_lat =0.0;
  double current_lng= 0.0;


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.7172, 85.3240),
    zoom: 14.4746,
  );

  Set<Marker> _markers =  Set<Marker>();
  Set<Polygon> _polygons =  Set<Polygon>();
  Set<Polyline> _polyline =  Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCount = 1;
  int _polylineIdCount = 1;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentLocation();

  }

  void _setMarker(LatLng point){

     setState(() {
       _markers.add(
         Marker(markerId: MarkerId("marker"),position: point),
       );
     });

  }

  void setPolygon(){
    final String polygonIdVal = 'polygon_$_polygonIdCount';
    _polygonIdCount ++ ;
    _polygons.add(Polygon(polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent
    ));

  }

  void setPolyline(List <PointLatLng>points) {
    final String polylineIdVal = 'polyline_$_polylineIdCount';
    _polylineIdCount++;
    _polyline.add(Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points.map((point) => LatLng(point.latitude, point.longitude)).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: SafeArea(

        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title:Text("Book Your Ride",style: appBarTextStyle,),
          backgroundColor: Colors.red.shade50,

          ),
          drawer: Drawer(

            child: ListView(

              padding: EdgeInsets.zero,
              children: [
                 DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                  ),
                  child: Text('Drawer Header'),
                ),
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () {

                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Item 2'),
                  onTap: () {

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              Column(

                children: [
                  Flexible(
                    child: Container(

                      child: GoogleMap(
                        markers: _markers,
                        polygons: _polygons,
                        polylines: _polyline,
                        mapType: MapType.normal,
                        initialCameraPosition: _kGooglePlex,

                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          googleMapController = controller;

                        },
                        onTap: (point){
                          polygonLatLngs.add(point);
                          setPolygon();
                        },

                      ),


                    ),
                  ),

                  Flex(
                    direction: Axis.vertical,

                    children: [

                      Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: SearchMapPlaceWidget(
                          bgColor: Colors.blue.shade50,
                          hasClearButton: true,
                          textColor: Colors.black,
                          placeType: PlaceType.address,
                          placeholder: "Enter the origin",
                          apiKey: "AIzaSyDjTJsc1uhHKEeaRl7I_xvuT4sDR9vDf6E",
                          onSelected: (Place place)async{

                            Geolocation? geolocation =await place.geolocation;
                            setState(() {
                              org = place.description.toString();
                            });
                            log("org---------------------"+org);
                            log("org latitude::::::"+geolocation!.coordinates.latitude.toString());
                            log("org longitude::::::"+geolocation!.coordinates.longitude.toString());
                            locationService.getPlaceOrg(place.placeId.toString());

                            googleMapController.animateCamera(
                                CameraUpdate.newLatLng(
                                    geolocation!.coordinates
                                )
                            );
                            googleMapController.animateCamera(
                              CameraUpdate.newLatLngBounds(geolocation.bounds, 0),

                            );
                            // _setMarker(LatLng(, lng));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: SearchMapPlaceWidget(
                          bgColor: Colors.blue.shade50,
                          textColor: Colors.black,
                          hasClearButton: true,
                          placeType: PlaceType.address,
                          placeholder: "Enter the destination",
                          apiKey: "AIzaSyDjTJsc1uhHKEeaRl7I_xvuT4sDR9vDf6E",
                          onSelected: (Place place)async{
                            Geolocation? geolocation =await place.geolocation;
                            setState(() {
                              des = place.description.toString();
                            });
                            log("dest latitude::::::"+geolocation!.coordinates.latitude.toString());
                            log("dest longitude::::::"+geolocation!.coordinates.longitude.toString());
                            locationService.getPlaceDest(place.placeId.toString());
                            googleMapController.animateCamera(
                                CameraUpdate.newLatLng(
                                    geolocation!.coordinates
                                )
                            );
                            googleMapController.animateCamera(
                                CameraUpdate.newLatLngBounds(geolocation.bounds, 0)
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 5,),
                      org==''&&des==''?ElevatedButton(
                        onPressed: () {

                          Fluttertoast.showToast(msg: "Please select your origin and desination");

                        },
                        child: Text("Find a Driver"),
                        style: ElevatedButton.styleFrom(
                            primary: org==''&&des==''?Colors.grey:Colors.red,
                            textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  15,
                                ))),
                      ):
                      ElevatedButton(
                        onPressed: () async{
                          _markers.clear();
                          _polyline.clear();


                          var directions= await locationService.getDirection(org, des);

                          _goToThePlace(
                            directions['end_location']['lat'],
                            directions['end_location']['lng'],
                            directions['bounds_ne'],
                            directions['bounds_sw'],
                          );
                          setPolyline(directions['polyline_decoded']);
                        },
                        child: Text("Find a Driver"),
                        style: ElevatedButton.styleFrom(
                            primary: org==''&&des==''?Colors.grey:Colors.red,
                            textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  15,
                                ))),
                      ),


                    ],

                  ),
                ],
              ),
            ],
          )

        ),
      ),
    );
  }


  Future<void> _goToThePlace(
      // Map<String,dynamic> place
      double lat,
      double lng,
      Map<String,dynamic> boundsNe,
      Map<String,dynamic> boundsSw,
      ) async {
    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat,lng),zoom: 16),
    ));

    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(boundsSw['lat'],boundsSw['lng']),
          northeast: LatLng(boundsNe['lat'],boundsNe['lng']),
        ),
        25
    ));

    _setMarker(LatLng(lat, lng));
  }

  Future<Position> _determinePosition()async{
    bool serviceEnabled ;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled)
    {
      return Future.error("error");
    }
    permission = await Geolocator.checkPermission();

    if(permission==LocationPermission.denied){
      permission = await Geolocator.requestPermission();

      if(permission==LocationPermission.denied){
        return Future.error("Permission denied!");
      }
    }
    if(permission==LocationPermission.deniedForever){
      return Future.error("Location Permission denied forever!");
    }

    Position position = await Geolocator.getCurrentPosition();

// lat and lng
    log("+++++++++++"+position.latitude.toString());
    current_lat = position.latitude;
    current_lng = position.longitude;
    // _setMarker(LatLng(Geolocator.));
    return position;




  }

  Future currentLocation()async{
    Position position = await _determinePosition();
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude,position.longitude),
        zoom: 16
    )));
    _markers.clear();

    _markers.add(Marker(markerId: MarkerId('currentLocation'),position: LatLng(
        position.latitude,position.longitude
    )));
    saveCurrentLocation(current_lat, current_lng);
    setState(() {

    });
  }


  Future<bool> exitAppConfirm(BuildContext context) async{
    bool exitApp = await showDialog(
      barrierColor: Colors.black38,

      context: context,

      builder: (context) => Dialog(
        backgroundColor: Colors.indigo.shade50,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(child: Text("Are you sure want to Exit?",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),)),
                    Container(
                      child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop(false);
                          },
                          style: ElevatedButton.styleFrom(
                            // primary: Colors.red,
                              minimumSize: const Size.fromHeight(30),

                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              )
                            // maximumSize: const Size.fromHeight(56),
                          ),
                          child:  Text(
                            "No",
                            style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                          // handleTick();
                          // data['content'][index]['isFinished'].toString()=="false"? Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanProgressPageInventoryPatch(id: data['content'][index]['id'],))):Fluttertoast.showToast(msg: "Task Completed");
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff018324),
                            minimumSize: const Size.fromHeight(30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                          // maximumSize: const Size.fromHeight(56),
                        ),
                        child:  Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )),

                  ],
                ),
              ),
            ),
            Positioned(
                top:-35,

                child: CircleAvatar(
                  child: Icon(Icons.book_outlined,size: 40,),
                  radius: 40,
                )),
          ],
        ),
      ),

    );
    return exitApp?? false;
  }

}


// Container(
//       color: Colors.grey.shade200,
//       child: IconButton(
//           onPressed: () async{
//           Position position = await _determinePosition();
//           googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//             target: LatLng(position.latitude,position.longitude),
//             zoom: 14
//           )));
//           _markers.clear();
//
//           _markers.add(Marker(markerId: MarkerId('currentLocation'),position: LatLng(
//             position.latitude,position.longitude
//           )));
//           setState(() {
//
//           });
//           },
//           icon: Icon(Icons.search)),
//     ),