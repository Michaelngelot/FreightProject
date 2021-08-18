import 'dart:async';

import 'package:flutter/material.dart';
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

  //Setting initial cameraPosition
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Cargo Freight"),
      ),
      body: Stack(
          children: [
               GoogleMap(
    mapType: MapType.normal,
    myLocationButtonEnabled: true,
                 initialCameraPosition: _kGooglePlex,
                 onMapCreated: (GoogleMapController controller){
                      _controllerGoogleMap.complete(controller);
                      newGoogleMapController = controller;
              },
               ),
],
      ),
    );
  }
}