import 'dart:async';

import 'package:final_project/AllWidgets/Divider.dart';
import 'package:final_project/Assistants/AssistantMethods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainScreen extends StatefulWidget{

  //routing variable
  static const String idScreen = "mainScreen ";
  @override
  _MainScreenState createState()=> _MainScreenState();
}


class _MainScreenState extends State<MainScreen>{
  //Google Map controller
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  //New googleMap location
  late GoogleMapController newGoogleMapController;

  //Drawer key
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  //Variable to get users current location
  //to get the latitude and longitude
  late Position currentPosition;
   var geoLocator =Geolocator();

  double bottomPaddingOfMap = 0;
   //Locate user current position
   void locatePosition() async
   {

     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     currentPosition = position;

     //Instance of longitude and latitude
     LatLng latLatPosition = LatLng(position.latitude, position.longitude);

     CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 15);
     newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));


     String address = await AssistantMethods.searchCoordinateAddress(position);
     print("Your are here" + address);
   }


 //Setting initial cameraPosition
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(5.593203, -0.233875),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text("Cargo Freight"),
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
                      Image.asset("images/user_icon.png", height: 65.0, width: 65.0,),
                      SizedBox(width: 16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Profile Name", style:  TextStyle(fontSize: 16.0),),
                          SizedBox(height: 6.0,),
                          Text("View Profile"),


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
      )  ,
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
                 //When map is created
                 onMapCreated: (GoogleMapController controller)
                 {
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
                onTap: (){
                  //openDrawer
                      scaffoldkey.currentState!.openDrawer();
                },
                //Drawer
                child: Container(
                  decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color:  Colors.black,
                      blurRadius: 6.0,
                    spreadRadius: 0.5,
                      offset: Offset(
                        0.7,.07
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)
                ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    ),
                  ],
              ),
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                   child: Column(
                      children: [
                      SizedBox(height: 6.0,),
                     Text("Hi there", style: TextStyle( fontSize: 12.0),),
                      Text("Where to?", style: TextStyle( fontSize: 20.0),),
                        SizedBox(height: 20.0,),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset (0.7,0.7),
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

                        SizedBox(height:  24.0),
                        Row(
                          children: [
                          Icon(Icons.home, color: Colors.black54,),
                            SizedBox(width: 12.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Add home"),
                                SizedBox(height: 4.0,),
                                Text("Your home address", style: TextStyle(color: Colors.black54, fontSize: 12.0,),
                            )


                          ],
                            )
        ]
    ),              SizedBox(height:  10.0),
                    DividerWidget(),

                   SizedBox(height:  16.0),

                   Row(
                       children: [
                         Icon(Icons.work, color: Colors.grey,),
                         SizedBox(width: 12.0,),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text("Add work"),
                             SizedBox(height: 4.0,),
                             Text("Your office address", style: TextStyle(color: Colors.black54, fontSize: 12.0,),
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

}