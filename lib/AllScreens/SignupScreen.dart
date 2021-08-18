import 'package:final_project/AllScreens/loginScreen.dart';
import 'package:final_project/AllScreens/mainscreen.dart';
import 'package:final_project/AllWidgets/progressDialog.dart';
import 'package:final_project/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class SignupScreen extends StatelessWidget {

  //Routing variable
  static const String idScreen = "Signup";

  //Text field controllers to hold user data
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      //logo image/background
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
                children: [
                  SizedBox(height:  60.0,),
                  Image(
                    image: AssetImage("images/logo.png"),   //image
                    width: 200.0,
                    height:100.0,
                    alignment: Alignment.center ,
                  ),

                  SizedBox(height: 1.0,),
                  Text(
                      "Rider SignUp",
                      style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                      textAlign: TextAlign.center
                  ),

                  Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          //Name text field
                          SizedBox(height: 1.0,),
                          TextField(
                            //Name controller
                            controller: nameTextEditingController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Name",
                                  labelStyle: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                  )
                              ),
                              style: TextStyle(fontSize: 18.0)
                          ),

                          //email text field
                          SizedBox(height: 1.0,),
                          TextField(
                            //Email controller
                              controller: emailTextEditingController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: "Email",
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

                          //Password text field
                          SizedBox(height: 1.0,),
                          TextField(
                            //Password controller
                              controller: passwordTextEditingController,
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


                          //Button Signup
                          SizedBox(height: 30.0,),
                          RaisedButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Container(
                                height: 50.0,
                                child: Center(
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                                    )

                                ),
                              ),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(24.0),

                              ),

                              //signup button
                              onPressed:()
                              {
                                //condition to check user registration
                                if(nameTextEditingController.text.length < 5)
                                  {
                                    displayToastMessage("name must be at least five characters", context);
                                  }
                                else if(!emailTextEditingController.text.contains("@"))
                                {
                                  displayToastMessage("invalid email", context);
                                }
                                else if(passwordTextEditingController.text.length < 6)
                                {
                                  displayToastMessage("password not less then 6 characters", context);
                                }
                                else {
                                  registerNewUser(context);
                                }
                              }
                          )
                        ],
                      )
                  ),
                  FlatButton(
                      onPressed: ()
                      {
                        Navigator.pushNamedAndRemoveUntil(context, loginScreen.idScreen, (route) => false);
                      },
                      child: Text (
                          "Already have an account? Login."
                      )
                  )
                ]
            ),
          ),
        )
    );
  }

  //Implementing/calling firebase authenticator
 final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //function to create new user
 void registerNewUser(BuildContext context)async
 {
   showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext context)
       {
         return ProgressDialog(message:  "Please wait...",);
       }
   );
 final User? firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword(
     email: emailTextEditingController.text,
     password: passwordTextEditingController.text).catchError((erMsg){
   Navigator.pop(context);
       displayToastMessage("Error:" + erMsg.toString(), context);
       
 })).user;


if(firebaseUser!=null) //user created
    {
  //save user info to database
  Map userDataMap = {
    "name": nameTextEditingController.text.trim(),
    "email": emailTextEditingController.text.trim(),
  };

  usersRef.child(firebaseUser.uid).set(userDataMap);
  displayToastMessage("Account created", context);

  //Route to mainScreen
  Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
}
  
else{
  //error occurred-display error
  displayToastMessage("User not created", context);
}
 }

}

//Display toast/error message function
displayToastMessage(String message, BuildContext context ){
  Fluttertoast.showToast(msg: message);
}
