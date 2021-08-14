import 'package:final_project/AllScreens/loginScreen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {

  //Routing variable
  static const String idScreen = "Signup";

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
                  SizedBox(height: 60.0,),
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
                          //Email text field
                          SizedBox(height: 1.0,),
                          TextField(
                              keyboardType: TextInputType.emailAddress,
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

                          //Password text field
                          SizedBox(height: 1.0,),
                          TextField(
                              keyboardType: TextInputType.text,
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
                              color: Colors.grey,
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
                              { //to be routed later
                                print("SignUp Successfull");
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
}
