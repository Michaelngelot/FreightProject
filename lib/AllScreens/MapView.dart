import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  static const String idScreen = "mapView ";

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? currentPosition;
  final Completer<GoogleMap> _controller = Completer();
  Set<Marker> markers = {};

  @override
  void initState(){
    getCurrentLocation();
    super.initState();
  }

  //Locate user current position
  void getCurrentLocation() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {

      //Instance of longitude and latitude
      currentPosition = LatLng(position.latitude, position.longitude);

      markers.add(
          Marker(markerId:MarkerId("12"),
            position: currentPosition!,
            infoWindow: InfoWindow(title: "Hi"),

          )
      );
});
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: currentPosition != null
        ? GoogleMap(
          mapType: MapType.normal,
          markers: markers,
          initialCameraPosition: CameraPosition(target: currentPosition!, zoom: 15),
          onMapCreated: (GoogleMapController controller){
            _controller.complete();
          },
      )
    :SizedBox.shrink(),
    );



    //Side Drawer

  }
}