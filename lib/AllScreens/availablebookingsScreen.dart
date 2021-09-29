import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AvailableBookingScreen extends StatefulWidget {
  static const String idScreen = "availablebookings";

  @override
  _AvailableBookingScreenState createState() => _AvailableBookingScreenState();
}
class AvailableBookingData{
  String  car, phone, departureTime, storage, finalDestination ;
  AvailableBookingData( this.car,this.storage, this.phone, this.finalDestination, this.departureTime, );
}

class _AvailableBookingScreenState extends State<AvailableBookingScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference DBRef = FirebaseDatabase.instance.reference().child(
      'users/Forms');
  List<AvailableBookingData> dataList = [];

  @override
  void initState() {
    super.initState();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference DBRef = FirebaseDatabase.instance.reference().child(
        'users/Forms');
    DBRef.child(uid).once().then((DataSnapshot dataSnapshot) {
      //dataList.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      for (var key in keys) {
        AvailableBookingData data = new AvailableBookingData(
          values [key]["car"],
          values [key]["storage"],
          values [key]["phone"],
          values [key]["finalDestination"],
          values [key]["departureTime"],
        );
        dataList.add(data);
      }
      setState(() {
        //
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(" Add Availability"),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,

        body: dataList.length == 0 ? Center(
          child: Text("No Data Available",
            style: TextStyle(fontSize: 30),),
        ) : ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (_, index) {
            return CardUI(
              dataList[index].car,
              dataList[index].storage,
              dataList[index].phone,
              dataList[index].finalDestination,
              dataList[index].departureTime,
            );
          },
        )
    );
  }

  Widget CardUI(String car,
      String storage,
      String phone,
      String finalDestination,
      String departureTime,) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    Text(' Truck Type: ', style: GoogleFonts.oswald(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),),
                    Text(car, style: GoogleFonts.firaSans(fontSize: 16),)
                  ],),
                ],
                ),

                Row(children: [
                  Text(' Storage:  ', style: GoogleFonts.oswald(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),),
                  Text(storage, style: GoogleFonts.firaSans(fontSize: 16),)
                ],),
                Row(children: [
                  Text(' Phone: ', style: GoogleFonts.oswald(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),),
                  Text(phone, style: GoogleFonts.firaSans(fontSize: 16),)
                ],),
                Row(children: [
                  Text(' Destination: ', style: GoogleFonts.oswald(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),),
                  Text(finalDestination,
                    style: GoogleFonts.firaSans(fontSize: 16),)
                ],),
                Row(children: [
                  Text(' Departure Date: ', style: GoogleFonts.oswald(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),),
                  Text(
                    departureTime, style: GoogleFonts.firaSans(fontSize: 16),)
                ],),

              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)
              ),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.symmetric(vertical: 10),

                  child: GestureDetector(
              child: Text(
                'Delete', style: GoogleFonts.robotoMono(color: Colors.white,
                 fontWeight: FontWeight.bold, fontSize: 16),
    ),
                    onTap: () => showDialog<String>(
    context: context,
    builder: (BuildContext context) => Container(
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18))),
      title: const Text('DELETE!'),
      content: const Text('DO YOU REALLY WANT TO DELETE THIS FORM?'),
      actions: <Widget>[
      TextButton(
      onPressed: () => Navigator.pop(context, 'Cancel'),
      child: const Text('Cancel'),
      ),TextButton(
          child: const Text('Approve'),
          onPressed: () {
            delete(context);
            Navigator.of(context).pop();
          },
        ),
      ],
      ),
    )
                    ),
    ),
                ) ],

    ),
          ),
        ],
      ),
    );
  }

  delete(BuildContext context) {
    DBRef.child(uid).remove();
    Navigator.pop(context);
   }


}
