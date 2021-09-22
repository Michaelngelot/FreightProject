
import 'package:final_project/Assistants/requestAssistant.dart';
import 'package:final_project/DataHandler/appData.dart';
import 'package:final_project/Models/address.dart';
import 'package:final_project/Models/allUsers.dart';
import 'package:final_project/Models/directionDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../configMaps.dart';


class AssistantMethods {
  //perform geocoding request
  //if any error come remove BuildContext
  static Future<String> searchCoordinateAddress(context,Position position) async
  {

    String placeAddress = "";
    //String st1,st2,st3,st4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    //Calling from request Assistant class
    var res = await RequestAssistant.getRequest(Uri.encodeFull(url));

    if(res !="failed")
      {
        //From the decoded jSon Data we get the formatted address

        placeAddress= res["results"][0]["formatted_address"];
        //Display specific location details from https://developers.google.com/maps/documentation/geocoding/start
        //st1 =  res["results"][0]["address_components"][3]["long_name"];
        //st2 =  res["results"][0]["address_components"][4]["long_name"];
       // st3 =  res["results"][0]["address_components"][5]["long_name"];
       // st4 =  res["results"][0]["address_components"][6]["long_name"];
        //placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;

        //Get user address details from address class
        Address userPickUpAddress = new Address(placeFormattedAddress: '',placeID: '',placeName: '',latitude: 0,longitude: 0);  //
        userPickUpAddress.longitude = position.latitude;
        userPickUpAddress.latitude = position.latitude;
        userPickUpAddress.placeName= placeAddress;

        Provider.of<AppData>(context, listen: false ).updatePickUpLocationAddress(userPickUpAddress);
      }
  return placeAddress;
  }

  //Get direction details

    static Future<DirectionDetails?>obtainPlaceDirectionDetails (LatLng initialPosition, LatLng finalPosition) async
  {
      String directionalUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    //String directionalUrl= "https://maps.googleapis.com/maps/api/directions/json?origin=49.794150%2C-84.564514&destination=49.173205%2C-84.756775&key=AIzaSyCz5b_Z9M9Mhf-GwCN3M783WFl9xMGR9kw";
      //Calling from request Assistant class
      var res = await RequestAssistant.getRequest(Uri.encodeFull(directionalUrl));

      if(res == "failed")
      {
        return null;
      }
     // return placeAddress;


        DirectionDetails directionDetails = DirectionDetails(distanceValue: 0,
            durationValue: 0,
            distanceText: '',
            durationText: '',
            encodedPoints: '');

        directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];
        directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
        directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];
        directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
        directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];


        return directionDetails;
      }

      //calculation price fare
      static int calculateFare(DirectionDetails directionDetails)
      {
        //in terms USD
        double timeTravelFare = (directionDetails.durationValue /60) * 0.20;
        double distanceTravelFare = (directionDetails.durationValue /1000) * 0.20;
        double totalFareAmount = timeTravelFare + distanceTravelFare;

        //local
       // Users users     //1$ - 160 RS
        //double totalLocalAmount = totalFareAmount * 160;

        return totalFareAmount.truncate();
      }
       static void getCurrentOnlineUser() async {

        firebaseUser = FirebaseAuth.instance.currentUser;

        String userId = firebaseUser!.uid;
        DatabaseReference reference = FirebaseDatabase.instance.reference().child("Users").child(userId);

        reference.once().then((DataSnapshot dataSnapShot)
         {
            if(dataSnapShot.value !=null){
              userCurrentInfo = Users.fromSnaShot(dataSnapShot);
            }
         });
       }

  }



