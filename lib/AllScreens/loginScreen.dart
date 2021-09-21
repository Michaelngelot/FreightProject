import 'package:final_project/AllScreens/MapView.dart';
import 'package:final_project/AllScreens/SignupScreen.dart';
import 'package:final_project/AllWidgets/progressDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'mainscreen.dart';

class loginScreen extends StatelessWidget {

//Routing Variable
  static const String idScreen = "login";

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context)  {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding:EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 45.0,),
                Image(
                  image: AssetImage("images/logo.png"),
                  width: 350.0,
                  height:250.0,
                  alignment: Alignment.center ,
                ),

                SizedBox(height: 1.0,),
                Text(
                  "Login as a Rider",
                  style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                  textAlign: TextAlign.center
                ),

                Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    //Email text field
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 18.0)
                    ),

                    //Password text field
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController ,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              fontSize: 18.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14.0)
                    ),

                    //Button login
                    SizedBox(height: 30.0,),
                    RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                          )

                      ),
                      ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(24.0),

                    ),

                        onPressed:()
                    {
                      if(!emailTextEditingController.text.contains("@"))
                      {
                        displayToastMessage("Invalid email", context);
                      }
                      else if(emailTextEditingController.text.isEmpty)
                      {
                        displayToastMessage("Email Required", context);
                      }
                      else if(passwordTextEditingController.text.isEmpty)
                      {
                        displayToastMessage("Password Required", context);
                      }
                      else {
                        loginAndAuthenticateUser(context);
                      }

                    }
                    )
                    ],
                )
                ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, SignupScreen.idScreen, (route) => false);
                },
                child: Text (
                  "New Driver? SignUp Today!",
                )
              )
              ]
            ),
          ),
        )
      );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
 void loginAndAuthenticateUser(BuildContext context) async
 {

   //Show progress status during registration/ login
   showDialog(
       context: context,
     barrierDismissible: false,
     builder: (BuildContext context)
     {
         return ProgressDialog(message:  "Authentication. Please wait...",);
     }
   );
   final User? firebaseUser = (await _firebaseAuth
       .signInWithEmailAndPassword(
       email: emailTextEditingController.text,
       password: passwordTextEditingController.text).catchError((erMsg){
         Navigator.pop(context);
     displayToastMessage("Error: " + erMsg..toString(), context);

   })).user;

   if(firebaseUser!=null) //user created
       {
         //check if user is already registered
         usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
    if(snap.value!=null)
    {
      //Route to mainScreen
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
      displayToastMessage("Signed In", context);
    }
    else{
      Navigator.pop(context);
      _firebaseAuth.signOut();
      displayToastMessage("Account not found. Proceed to sign up.", context);
    }
});
    }
   else{
     Navigator.pop(context);
     displayToastMessage("Error occurred. Sign in failed", context);
   }

 }
}
