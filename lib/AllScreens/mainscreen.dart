import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:final_project/AllScreens/SearchScreen.dart';
import 'package:final_project/AllScreens/loginScreen.dart';
import 'package:final_project/AllWidgets/Divider.dart';
import 'package:final_project/AllWidgets/progressDialog.dart';
import 'package:final_project/Assistants/AssistantMethods.dart';
import 'package:final_project/DataHandler/appData.dart';
import 'package:final_project/Models/directionDetails.dart';
import 'package:final_project/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class MainScreen extends StatefulWidget{

  //routing variable
  static const String idScreen = "mainScreen ";
  @override
  _MainScreenState createState()=> _MainScreenState();
}


class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{
  //Google Map controller
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  //New googleMap location
  late GoogleMapController newGoogleMapController;
  //Drawer key
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
 DirectionDetails ? tripDirectionDetails;

  List<LatLng>pLineCoordinates = [];
  Set<Polyline> polyLineSet = {};

  //Variable to get users current location
  //to get the latitude and longitude
  late Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0.0;
  Set<Marker> markerSet ={};
  Set<Circle> circlesSet = {};

  double rideDetailsContainerHeight = 0;
  double searchContainerHeight=300.0;
  double requestRideContainerHeight = 0;

  //Button drawer variable
  bool drawerOpen = true;

  late DatabaseReference riderRequestRef;

//Reset App
  restApp(){
     setState(() {
       drawerOpen =true;

       searchContainerHeight = 300;
       rideDetailsContainerHeight = 0;
       bottomPaddingOfMap = 230.0;
       requestRideContainerHeight=0;
       polyLineSet.clear();
       markerSet.clear();
       circlesSet.clear();
       pLineCoordinates.clear();
     });

     locatePosition();
  }


  //Retrieve and store current user data
  @override
  void initState(){
    super.initState();

    AssistantMethods.getCurrentOnlineUser();
  }

  //Store to storeRide information
    void savedRequestRide(){
      riderRequestRef = FirebaseDatabase.instance.reference().child("Ride Request").push();
      var pickUp = Provider.of<AppData>(context, listen:false).pickUpLocation;
      var dropOff = Provider.of<AppData>(context, listen:false).dropOffLocation;


      Map pickUpLocMap =
      {
        "latitude" : pickUp!.latitude.toString(),
        "longitude" : dropOff!.latitude.toString(),


      };

      Map dropOffLocMap =
      {
        "latitude" : pickUp.latitude.toString(),
        "longitude" : dropOff.latitude.toString(),


      };

      //Information which will be stored into database
      Map rideInfoMap =
      {
        "driver_id" : "waiting",
        "payment_method": "cash",
        "pickUp" : pickUpLocMap,
        "dropOff": dropOffLocMap,
        "created_at": DateTime.now().toString(),
        "rider_name" : userCurrentInfo!.name,
        "rider_phone": userCurrentInfo!.phone,
        "pickUp_address": pickUp.placeName,
        "dropOff_address" : dropOff.placeName,
      };

      //Push info/store info into database
      riderRequestRef.set(rideInfoMap);
    }


//Cancel ride request
  void cancelRideRequest ()
  {
riderRequestRef.remove();
  }

  displayRequestContainer(){
    setState(() {
      requestRideContainerHeight = 250.0;
      rideDetailsContainerHeight=0;
      bottomPaddingOfMap = 230.0;
      drawerOpen=true;
    });

    //Calling ride request method
    savedRequestRide();
  }


//Display ride details
  void displayRideDetailsContainer() async{
    await getPlaceDirection();


    setState(() {
searchContainerHeight =0;
rideDetailsContainerHeight = 240.0;
bottomPaddingOfMap = 230.0;
drawerOpen=false;
    });

  }

//Locate user current position
  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {

      //Instance of longitude and latitude
      LatLng latLatPosition = LatLng(position.latitude, position.longitude);

      markerSet.add(
          Marker(markerId:MarkerId("12"),

          )
      );

      CameraPosition cameraPosition = new CameraPosition(
          target: latLatPosition, zoom: 15);
      newGoogleMapController.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition));

    });



    String address = await AssistantMethods.searchCoordinateAddress(
        context, position);
    print("Your location :: " + address);
  }


  //Setting initial cameraPosition
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(5.5976, -0.2493),
    zoom: 14.4746,
  );

  //Animated text color
  static const colorizeColors = [
    Colors.green,
    Colors.purple,
    Colors.pink,
    Colors.blue,
    Colors.yellow,
    Colors.red,

  ];


  static const colorizeTextStyle = TextStyle(
    fontSize: 20.0,
    fontFamily: 'bolt-regular',

  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,

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
               GestureDetector(
                 onTap: (){
                   FirebaseAuth.instance.signOut();
                   Navigator.pushNamedAndRemoveUntil(context, loginScreen.idScreen, (route) => false);
                   },
                 child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text("Sign Out", style: TextStyle(fontSize: 15.0),),
              ),
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

          //Hamburger Button drawer
          Positioned(
            top: 30.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                //openDrawer

                if(drawerOpen){
                  scaffoldkey.currentState!.openDrawer();
                }
                else
                  {
                    restApp();
                  }

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
                          0.7,
                          0.7,
                      ),

                    ),
                  ],
                ),
                //round drawer
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon((drawerOpen) ? Icons.menu : Icons.close, color: Colors.black , ),

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
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: searchContainerHeight,
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
                               displayRideDetailsContainer();
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
                                            .of<AppData>(context).pickUpLocation != null
                                            ? Provider.of<AppData>(context).pickUpLocation!.placeName
                                            : "Add home"
                                    ),
                                    SizedBox(height: 4.0,),
                                    Text("Your home address", style: TextStyle(
                                      color: Colors.black54, fontSize: 12.0,),
                                    ),

                                  ],
                                ),
                              ],
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
            ),
          ),

          //Price and car container
          Positioned(
            bottom: 0.0,
            left:0.0,
            right:0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: rideDetailsContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                    boxShadow:[
                      BoxShadow(
                              color:Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7,0.7),
                      )
                    ]
                ),
                child:  Padding(
                  padding: EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      Container(
                      width: double.infinity,
                        color: Colors.tealAccent[100],
                        child: Padding (
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              //Adding taxi image
                              Image.asset("images/taxi.png", height: 70.0, width: 80.0,),
                              SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Car", style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold")
                                  ),
                                  Text(
                                      (( tripDirectionDetails !=null) ? tripDirectionDetails!.distanceText : ''),
                                      style: TextStyle(fontSize: 18.0, color: Colors.black54)

                                  ),
                                ],

                              ),
                              Expanded(

                                  child: Container()),
                              Text (
                                  (( tripDirectionDetails !=null) ? '\$${ AssistantMethods.calculateFare(tripDirectionDetails!)}' : ''),
                                  style: TextStyle(fontSize: 18.0, color: Colors.black54)

                               ),


                            ],
                          ),

                        ),
                      ),

                      SizedBox(height: 20.0,),
                                   //Cash
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.moneyCheckAlt, size: 18.0, color: Colors.black54,),
                            SizedBox(width: 16.0,),
                            Text("Cash"),
                            SizedBox(width: 6.0),
                            Icon(Icons.keyboard_arrow_down, color: Colors.black54,)

                          ],
                        )
                      ),

                      SizedBox(height: 24.0),


                      Padding(
                        padding: EdgeInsets.symmetric(horizontal:16.0),
                        //Button Click event
                        child: RaisedButton(
                            onPressed: () {
                              displayRequestContainer();
                            },
                          color: Theme.of(context).accentColor,
                          padding: EdgeInsets.all(17.0),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("Request", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white ),),
                               Icon(FontAwesomeIcons.taxi, color: Colors.white,size: 26.0,)
                             ]
                          )
                        ),

                      )

                    ],
                  ),
                ),
              ),
            )

          ),

          //Design request container
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right:0.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 16.0,
                    color: Colors.black54,
                    offset: Offset(0.7,0.7),

                  ),
                ],
              ),

                height: requestRideContainerHeight,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0),

                    //Animated text
                      SizedBox(
                      width: double.infinity,
                        child: AnimatedTextKit(
                          animatedTexts: [
                          ColorizeAnimatedText(
                            'Connecting..',
                            textStyle: colorizeTextStyle,
                            colors: colorizeColors,
                            textAlign: TextAlign.center,
                          ),
                          ColorizeAnimatedText(
                            'Please wait...',
                            textStyle: colorizeTextStyle,
                            colors: colorizeColors,
                            textAlign: TextAlign.center,
                          ),
                            ColorizeAnimatedText(
                            'Finding driver',
                            textStyle: colorizeTextStyle,
                            colors: colorizeColors,
                              textAlign: TextAlign.center,
                            ),
                          ],
                          isRepeatingAnimation: true,
                          onTap: () {
                          print("Tap Event");
                          },

                          ),
                      ),

                    SizedBox(height: 22.0),

                    //cancel button
                    GestureDetector(
                      onTap: ()
                      {
                        cancelRideRequest();
                        restApp();
                      },

                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26.0),
                          border: Border.all(width: 2.0, color: Colors.grey),
                        ),
                        child: Icon(Icons.close, size: 26.0),
                      ),
                    ),

                    SizedBox(height: 10.0),

                    //Cancel ride
                    Container(
                      width:double.infinity,
                      child: Text("Cancel Ride", textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0),),
                    ),


                  ],
                ),
              ),
            ),
          ),

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
    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);
    print("This is Encoded point ::");
    print(details!.encodedPoints);


    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointResult = polylinePoints.decodePolyline(
        details.encodedPoints);

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

