import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets/NavigationDrawer.dart';
import '../constant.dart';


class MyBuySellPage extends StatefulWidget {
  const MyBuySellPage({Key? key}) : super(key: key);

  @override
  _MyBuySellPageState createState() => _MyBuySellPageState();
}

class _MyBuySellPageState extends State<MyBuySellPage> {
  var userEmail = FirebaseAuth.instance.currentUser!.email;

  final double spaceHeight =10;


  @override
  Widget build(BuildContext context) {
    var userName=NameExtract.extractUserNameFromEmail(userEmail!);
    final firebaseDatabaseRef = FirebaseDatabase.instance.ref('post').child(userName);

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
        title: Text('My Buy/Sell Page'),
          backgroundColor: appBarColor,
    ),

    drawer: NavigationDrawer(userName),
    body: FirebaseAnimatedList(
      query: firebaseDatabaseRef,
      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
        return Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            boxShadow: [
            BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 8),
          ),],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spaceHeight,),



              Row(
                children: [
                  CircleAvatar(child: Icon(Icons.arrow_forward_ios,size: 15,),radius:14 ,),
                  SizedBox(width: 5,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${snapshot.child('stockName').value.toString()}",
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      Text("${snapshot.child('fullStockName').value.toString()}",
                        style: TextStyle(fontSize: 10),),

                    ],
                  ),
                ],
              ),




              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(onPressed: (){
                    print(userName);
                    final stockRef = FirebaseDatabase.instance.ref('stock').child(snapshot.key!).remove();
                    final stockPostRef =FirebaseDatabase.instance.ref('post')
                        .child(userName).child(snapshot.key!).remove();
                    showSnackBar(context,"Removed Sucessfully...!");
                  }, icon: Icon(Icons.delete,color: Colors.red,), label:Text("Cancel")),
                  Column(
                    children: [
                      Text("Quantity: ${snapshot.child('quantity').value.toString()}",style: cardText,),
                      Text("Price: Rs.${snapshot.child('price').value.toString()}",style: cardText,),
                      SizedBox(height: 2,),
                      Text("Status = ${snapshot.child('status').value.toString().toUpperCase()}",style: TextStyle(fontSize: 12),),

                    ],
                  ),
                ],
              ),
            ],
          ),
        );
          //ListTile(
          //title: Text(snapshot.child('price').value.toString()),
        //);
      },

    ),

    );
  }
}



