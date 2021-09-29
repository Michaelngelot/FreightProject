import 'package:final_project/AllScreens/mainscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  static const String idScreen = "bookingscreen";

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
//Call object of MainScreen class


  String uid = FirebaseAuth.instance.currentUser!.uid;

  DatabaseReference usersRef = FirebaseDatabase.instance.reference().child('Forms');

  TextEditingController carTextEditingController = TextEditingController();

  TextEditingController storageTextEditingController = TextEditingController();

  TextEditingController destinationTextEditingController = TextEditingController();

  TextEditingController phoneTextEditingController = TextEditingController();

  TextEditingController dateTextEditingController = TextEditingController();

  _selectedTodoDate(BuildContext context)async{
    var _pickedDate = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2025));
    if (_pickedDate!=null){
      setState(() {
        dateTextEditingController.text=DateFormat('dd-MM-yyyy').format(_pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Edit Bookings Added"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(20.0),
                child: Column(
                  children:<Widget> [
                    SizedBox(height: 1.0,),

                    TextField(
                      controller: carTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        icon: Icon(Icons.local_shipping_rounded ),
                        labelText: "Truck type",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),

                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 1.0),

                    TextField(
                      controller: storageTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        icon: Icon(Icons.storage),
                        labelText: "Storage Description",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),

                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 1.0),
                    TextField(
                      controller: destinationTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        icon: Icon(Icons.location_on_sharp),
                        labelText: "Destination",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),

                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 1.0),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        icon: Icon(Icons.phone_sharp),
                        labelText: "Telephone",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),

                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0),
                    TextField(
                      controller: dateTextEditingController,
                      onTap: (){
                        _selectedTodoDate(context);
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.date_range_sharp),
                        labelText: "Departure Date (dd/MM/yy)",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),

                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 10.0),
                    RaisedButton(
                        color: Colors.orange,
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  fontSize: 18.0, fontFamily: "Brand Bold"),
                            ),
                          ),

                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0),
                        ),

                        onPressed: () {

                          if (carTextEditingController.text.isEmpty) {
                            displayToastMessage(
                                "CarType/Name is mandatory", context);
                          }
                          else if (storageTextEditingController.text.isEmpty) {
                            displayToastMessage("Storage/Space Available is mandatory",
                                context);
                          }
                          else if (phoneTextEditingController.text.isEmpty) {
                            displayToastMessage(
                                "Phone Number is mandatory", context);
                          }
                          else
                          if (destinationTextEditingController.text.isEmpty) {
                            displayToastMessage(
                                "Destination is mandatory", context);
                          }
                          else {
                            registerNewForm(context);
                          }
                        }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerNewForm(BuildContext context) {
Map<String, String> users ={
      "car": carTextEditingController.text.trim(),
      "storage": storageTextEditingController.text.trim(),
      "phone": '+233'+ phoneTextEditingController.text.trim(),
      "finalDestination": destinationTextEditingController.text.trim(),
      "departureTime": dateTextEditingController.text.trim(),
    };

   usersRef.push().set(users);
    displayToastMessage("Congratulations, your details have been submitted successfully", context);
    Navigator.pop(context);
  }

  displayToastMessage(String message, BuildContext context)
  {
    Fluttertoast.showToast(msg: message);
  }
}
