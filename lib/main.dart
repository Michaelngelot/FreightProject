import 'package:final_project/AllScreens/SignupScreen.dart';
import 'package:final_project/AllScreens/loginScreen.dart';
import 'package:final_project/AllScreens/mainscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


void main() async {
  //Initializing firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
DatabaseReference usersRef =FirebaseDatabase.instance.reference().child("drivers");
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cargo Freight',
      theme: ThemeData(
      fontFamily: "Arial",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //Routing pages
      initialRoute: loginScreen.idScreen,
      routes: {
       SignupScreen.idScreen: (context) => SignupScreen(),
      loginScreen.idScreen: (context) => loginScreen(),
        MainScreen.idScreen: (context) =>MainScreen(),

      },
      debugShowCheckedModeBanner: false,
    );
  }
}


