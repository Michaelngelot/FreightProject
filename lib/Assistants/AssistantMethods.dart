import 'package:final_project/Assistants/requestAssistant.dart';
import 'package:geolocator/geolocator.dart';

class AssistantMethods {
  //perform geocoding request
  static Future<String> searchCoordinateAddress(Position position) async
  {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position
        .latitude},${position
        .longitude}&key=AIzaSyCz5b_Z9M9Mhf-GwCN3M783WFl9xMGR9kw";

    var response = await RequestAssistant.getRequest(url);

    if(response !="failed")
      {
        placeAddress= response["results"][0]["formatted_address"];
      }
  return placeAddress;
  }
}