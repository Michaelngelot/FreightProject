import 'package:final_project/AllWidgets/Divider.dart';
import 'package:final_project/AllWidgets/progressDialog.dart';
import 'package:final_project/Assistants/requestAssistant.dart';
import 'package:final_project/DataHandler/appData.dart';
import 'package:final_project/Models/address.dart';
import 'package:final_project/Models/placePrediction.dart';
import 'package:final_project/configMaps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SearchScreen extends StatefulWidget {
  //static const String idScreen = "SearchScreen ";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
{

  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePrediction> placePredictionList = [];



  @override
  Widget build(BuildContext context)
  {
    //Retrieve address
   //you're giving me trouble, i'll be back
       String placeAddress=context.read<AppData>().pickUpLocation!.placeName;
     pickUpTextEditingController.text = placeAddress;

    return Scaffold(
        body: Column(
          children: [
            Container(

                height: 215.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 6.0,
                        spreadRadius: 0.5,
                        offset: Offset(.07,.07),
                      )
                    ]

                ),
                child: Padding(
                  padding:  EdgeInsets.only(left: 25.0, top:50.0, right: 25.0,bottom: 20.0 ),
                  child: Column(
                      children: [
                        SizedBox(height: 5.0),
                        Stack(
                          children: [
                            GestureDetector(
                              //Send user back to previous page
                              onTap:(){
                                Navigator.pop(context);
                              },
                              child: Icon(
                                  Icons.arrow_back
                              ),
                            ),
                            Center(
                              child: Text ("Set Drop off", style:TextStyle(fontSize: 18.0 ,fontFamily: "Brand Bold"),),
                            )
                          ],
                        ),

                        //PickUp
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            Image.asset('images/pickicon.png',height: 16.0,width: 16.0,),

                            SizedBox(height: 16.0),

                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(5.0)

                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(3.0) ,
                                  child: TextField(
                                    controller: pickUpTextEditingController,
                                    decoration: InputDecoration(
                                        hintText: "PickUp location",
                                        fillColor: Colors.grey[400],
                                        filled: true,
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0)
                                    ),
                                  ),
                                ),

                              ),

                            ),

                          ],
                        ),

                        //Destination
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            Image.asset('images/desticon.png',height: 16.0,width: 16.0,),


                            SizedBox(height: 10.0),

                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(5.0)

                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(3.0) ,
                                  child: TextField(
                                    //Call function findPlace anytime user type something
                                    onChanged: (val)
                                    {
                                      findPlace(val);
                                    },
                                    controller: dropOffTextEditingController,
                                    decoration: InputDecoration(
                                        hintText: "Where to",
                                        fillColor: Colors.grey[400],
                                        filled: true,
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0)
                                    ),
                                  ),
                                ),

                              ),

                            ),
                          ],
                        ),
                      ]),
                )
            ),
            
            
            //title for displaying predictions
            (placePredictionList.length >0)
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                child: ListView.separated(
                  padding: EdgeInsets.all(0.0),
                    itemBuilder:(context,index){
                      return PredictionTile(placePrediction: placePredictionList[index]);
                  },
        separatorBuilder: (BuildContext context, int index) => DividerWidget(),
itemCount: placePredictionList.length,
    shrinkWrap: true,
    physics: ClampingScrollPhysics(),

              ),
    )

    :Container()

  ]
     )
    );
  }



//Method to find place with the help of google places Api
void findPlace( String placeName) async
{
if(placeName.length > 1)
{
  //setting google autocomplete api url
  //Search can be made country specific or International
  //$component=country:GH makes place search specific to ghana
 String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890";

 var res = await RequestAssistant.getRequest(autoCompleteUrl);
 if (res == "failed"){
   return;
 }
//Check from JSON file for list of prediction
if(res["status"] =="OK"){

  var predictions = res["predictions"];

  var placeList = (predictions as List).map((e) => PlacePrediction.fromJson(e)).toList();

  setState(() {
    placePredictionList =placeList;
  });
}
}
}

}

//Prediction Tile
class PredictionTile extends StatelessWidget {
  late final PlacePrediction placePrediction;

  PredictionTile({Key? key, required this.placePrediction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

     return FlatButton(
         padding: EdgeInsets.all(0.0),
      onPressed: ()
      {
        //clickable tile places
       getPlaceAddressDetails(placePrediction.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0,),
           Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(placePrediction.main_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
                      SizedBox(height: 3.0,),
                      Text(placePrediction.secondary_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: Colors.grey),),

                    ],
                  ),
                )
              ],
            ),
            SizedBox(width:10.0),
          ],
        ),
      ),
    );
  }


   void getPlaceAddressDetails(String placeId, context) async
  {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(message: "Getting drop-off location...",)
    );

    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var res = await RequestAssistant.getRequest(placeDetailsUrl);
//Make dialog disappear
    Navigator.pop(context);

    if(res == "failed")
    {
      return;
    }

    if(res["status"] == "OK")
    {
      Address address =  Address(placeFormattedAddress: '',placeID: '',placeName: '',latitude: 0,longitude: 0);

      address.placeName = res["result"]["name"];
      address.placeID=placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);
      print("Drop off location Selected ::");
      print(address.placeName);

      Navigator.pop(context, "obtainDirection");
    }
  }
}
