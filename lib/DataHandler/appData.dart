import 'package:final_project/Models/address.dart';
import 'package:flutter/cupertino.dart';


class AppData extends ChangeNotifier
{
//Handle data across the whole app
//Create instance of address
 Address ? pickUpLocation;

void updatePickUpLocationAddress(Address pickUpAddress)
{

  pickUpLocation = pickUpAddress;
  notifyListeners();  //handle any change relative to pickUp location

}
}