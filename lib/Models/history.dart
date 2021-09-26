import 'package:firebase_database/firebase_database.dart';

class History
{
  late String paymentMethod;
   late String createdAt;
  late String status;
  late  String fares;
    late String dropOff;
  late String pickup;

  History(this.paymentMethod,this.createdAt,this.status,this.fares,this.dropOff, this.pickup);

  History.fromSnapshot(DataSnapshot snapshot)
  {
    paymentMethod = snapshot.value["payment_method"];
    createdAt = snapshot.value["created_at"];
    status = snapshot.value["status"];
    fares = snapshot.value["fares"];
    dropOff = snapshot.value["dropoff_address"];
    pickup = snapshot.value["pickup_address"];
  }
}