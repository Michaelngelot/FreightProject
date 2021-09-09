import 'dart:async';

import 'package:final_project/AllScreens/SearchScreen.dart';
import 'package:final_project/AllWidgets/Divider.dart';
import 'package:final_project/AllWidgets/progressDialog.dart';
import 'package:final_project/Assistants/AssistantMethods.dart';
import 'package:final_project/DataHandler/appData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class MainScreen extends StatefulWidget{

  //routing variable
  static const String idScreen = "mainScreen ";
  @override
  _MainScreenState createState()=> _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  //Google Map controller
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  //New googleMap location
  late GoogleMapController newGoogleMapController;

  //Drawer key
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  List<LatLng>pLineCoordinates = [];
  Set<Polyline> polyLineSet = {};

  //Variable to get users current location
  //to get the latitude and longitude
  late Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0.0;

  Set<Marker> markerSet ={};
  Set<Circle> circlesSet = {};



  //Locate user current position
  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    //Instance of longitude and latitude
    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(
        target: latLatPosition, zoom: 15);
    newGoogleMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));


    String address = await AssistantMethods.searchCoordinateAddress(
        context, position);
    print("Your location :: " + address);
  }


  //Setting initial cameraPosition
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.4221, -122.0841),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text("ECargo"),
      ),

      //Side Drawer
      drawer: Container(
        color: Colors.white,
        width: 300.0,
        child: Drawer(
          child: ListView(
            children: [
              //Drawer header
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/user_icon.png", height: 65.0, width: 65.0,),
                      SizedBox(width: 16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Profile Name", style: TextStyle(
                              fontSize: 16.0),),
                          SizedBox(height: 6.0,),
                          Text("View Profile")
                        ],
                      )
                    ],
                  ),
                ),
              ),
              DividerWidget(),
              SizedBox(height: 12.0,),
              //Drawer Body
              ListTile(
                leading: Icon(Icons.history),
                title: Text("History", style: TextStyle(fontSize: 15.0),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("View Profile", style: TextStyle(fontSize: 15.0),),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About", style: TextStyle(fontSize: 15.0),),
              ),

            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: polyLineSet,
            markers: markerSet,
            circles: circlesSet,
            //When map is created
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                bottomPaddingOfMap = 300.0;
              });
              // map is set correctly
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              //Location position is called
              locatePosition();
            },
          ),

          //Hamburger Button
          Positioned(
            top: 45.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                //openDrawer
                scaffoldkey.currentState!.openDrawer();
              },
              //Drawer
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                          0.7, .07
                      ),

                    ),
                  ],
                ),

              ),
            ),
          ),


          //Adding Home/Work
          //Creating Box
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 18.0),
                  child: Column(
                      children: [
                        SizedBox(height: 6.0,),
                        Text("Hi there", style: TextStyle(fontSize: 12.0),),
                        Text("Where to?", style: TextStyle(fontSize: 20.0),),
                        SizedBox(height: 20.0,),

                        //Adding click event to search Drop off
                        GestureDetector(
                          onTap: () async
                          {
                            //Navigator.pushNamedAndRemoveUntil(context, loginScreen.idScreen, (route) => false);
                            var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));

                            if (res == "obtainDirection") {
                             await getPlaceDirection();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 6.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7),
                                ),
                              ],
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.search, color: Colors.blueAccent),
                                  SizedBox(width: 10.0,),
                                  Text("Search Drop off")
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 24.0),
                        Row(
                            children: [
                              Icon(Icons.home, color: Colors.black54,),
                              SizedBox(width: 12.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    //Check if pickLocation has set or not
                                    //if not null display Add home

                                      Provider
                                          .of<AppData>(context)
                                          .pickUpLocation != null
                                          ? Provider
                                          .of<AppData>(context)
                                          .pickUpLocation!
                                          .placeName
                                          : "Add home"
                                  ),
                                  SizedBox(height: 4.0,),
                                  Text("Your home address", style: TextStyle(
                                    color: Colors.black54, fontSize: 12.0,),
                                  )


                                ],
                              )
                            ]
                        ), SizedBox(height: 10.0),
                        DividerWidget(),

                        SizedBox(height: 16.0),

                        Row(
                          children: [
                            Icon(Icons.work, color: Colors.grey,),
                            SizedBox(width: 12.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Add work"),
                                SizedBox(height: 4.0,),
                                Text("Your office address", style: TextStyle(
                                  color: Colors.black54, fontSize: 12.0,),
                                )
                              ],
                            ),
                          ],
                        ),
                      ])
              ),
            ),
          )
        ],
      ),
    );
  }

  //Getting place direction for the pick up location and destination location
  Future<void> getPlaceDirection() async
  {
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos!.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos!.latitude, finalPos.longitude);

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: 'Setting DropOff, Please wait...')
    );
    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);
    Navigator.pop(context);
    print("This is Encoded point ::");
    print(details?.encodedPoints);


    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointResult = polylinePoints.decodePolyline(
        details!.encodedPoints);

    pLineCoordinates.clear();

    if (decodedPolyLinePointResult.isNotEmpty) {
      decodedPolyLinePointResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates.add(
            LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
      polyLineSet.clear();

      setState(() {
        Polyline polyline = Polyline(
          color:  Colors.blue,
          polylineId: PolylineId("PolylineID"),
          jointType: JointType.round,
          points: pLineCoordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
        );
        polyLineSet.add(polyline);
      });

      LatLngBounds latLngBounds;
      if(pickUpLatLng.latitude > dropOffLatLng.latitude && pickUpLatLng.longitude > dropOffLatLng.longitude)
      {
        latLngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
      }
      else if(pickUpLatLng.longitude > dropOffLatLng.longitude)
      {
        latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
            northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
      }
      else if(pickUpLatLng.latitude > dropOffLatLng.latitude)
      {
        latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
            northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
      }
      else
      {
        latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
      }

      newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

//Adding markers and circles to map(polyline)

      Marker pickUpLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: initialPos.placeName, snippet: "My location"),
        position:  pickUpLatLng,
        markerId: MarkerId("pickUpId"),
      );

      Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: finalPos.placeName, snippet: "Drop-off location"),
        position:  dropOffLatLng,
        markerId: MarkerId("dropOffId"),
      );

      setState(() {
        markerSet.add(pickUpLocMarker);
        markerSet.add(dropOffLocMarker);
      });

      Circle pickUpLocCircle = Circle(
          fillColor: Colors.blue,
          center: pickUpLatLng,
          radius: 12,
          strokeWidth: 4,
          strokeColor: Colors.blueAccent,
          circleId: CircleId("pickUpId")
      );

      Circle dropOffLocCircle = Circle(
        fillColor: Colors.red,
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.redAccent,
        circleId: CircleId("dropOffId"),
      );

      setState(() {
        circlesSet.add(pickUpLocCircle);
        circlesSet.add(dropOffLocCircle);
      });
    }
  }
  }

