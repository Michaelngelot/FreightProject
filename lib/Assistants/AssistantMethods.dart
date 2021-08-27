
import 'package:final_project/Assistants/requestAssistant.dart';
import 'package:final_project/DataHandler/appData.dart';
import 'package:final_project/Models/address.dart';

import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';


class AssistantMethods {
  //perform geocoding request
  //if any error come remove BuildContext
  static Future<String> searchCoordinateAddress(context,Position position) async
  {

    String placeAddress = "";
    String st1,st2,st3,st4;

    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng="
        "${position.latitude},"
        "${position.longitude}&key=AIzaSyCz5b_Z9M9Mhf-GwCN3M783WFl9xMGR9kw";

    //Calling from request Assistant class
    var response = await RequestAssistant.getRequest(url);

    if(response !="failed")
      {
        //From the decoded jSon Data we get the formatted address

        placeAddress= response["results"][0]["formatted_address"];
        //Display specific location details from https://developers.google.com/maps/documentation/geocoding/start
        //st1 =  response["results"][0]["address_components"][3]["long_name"];
        //st2 =  response["results"][0]["address_components"][4]["long_name"];
       // st3 =  response["results"][0]["address_components"][5]["long_name"];
       // st4 =  response["results"][0]["address_components"][6]["long_name"];
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
}