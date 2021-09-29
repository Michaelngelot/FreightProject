import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/Models/allUsers.dart';

String mapKey = "AIzaSyCz5b_Z9M9Mhf-GwCN3M783WFl9xMGR9kw";

User ? firebaseUser;

Users ? userCurrentInfo;

int driverRequestTimeOut = 60;
String statusRide = "";
String rideStatus = "Driver is Coming";
String carDetailsDriver = "";
String driverName = "";
String driverphone = "";

double starCounter=0.0;
String title="";
String carRideType="";

String serverToken = "key=AAAAMdCI6eA:APA91bE4ySQXzU8nvU3Arcfailrk7jrZ7ZbX9Z6Iw2REQagS3XXK9ZEzyMCJPaJ6TZfwqO0ZVB_u-Ktq2STzeUnuilM6XLS0vjr-fNFzIGRFLt3L1NVac0VI3TwY-UvhT_aLjjGFDocY";