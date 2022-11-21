import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_navigation/Widgets/NavigationDrawer.dart';
import 'package:flutter_json_navigation/constant.dart';



class TranscationPage extends StatefulWidget {
  const TranscationPage({Key? key}) : super(key: key);

  @override
  _TranscationPageState createState() => _TranscationPageState();
}

class _TranscationPageState extends State<TranscationPage> {
  var userEmail = FirebaseAuth.instance.currentUser!.email;


  @override
  Widget build(BuildContext context) {
    var userName = NameExtract.extractUserNameFromEmail(userEmail!);
    final firebaseDatabaseRef =
    FirebaseDatabase.instance.ref('transcation').child(userName);

    
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar:AppBar(
        backgroundColor: appBarColor,
        title:Text('Transaction history'),
      ),
      drawer: NavigationDrawer(userName),
      body:FirebaseAnimatedList(query: firebaseDatabaseRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
        return (snapshot.child("transcationType").value.toString()=="sell")
            ?  // container for sell transcation
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            // borderRadius: BorderRadiusDirectional.only(
            //   topStart: Radius.circular(20),
            //   bottomEnd: Radius.circular(20),
            // ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(child:Text("S")
//                      Icon(Icons.arrow_forward_ios)
                      ),
                      SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${snapshot.child('stockName').value.toString()}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${snapshot.child('fullStockName').value.toString()}",
                            style: TextStyle(
                              fontSize: 10,),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.date_range),
                      Text(
                        "${snapshot.child('transcationDate').value.toString()}",
                        style: cardText,
                      ),
                    ],
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5,left: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${snapshot.child('quantity').value.toString()} Shares",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Cost Amount: Rs.${snapshot.child('costPrice').value.toString()}",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Sold Amount: Rs.${snapshot.child('sellingPrice').value.toString()}",
                          style: TextStyle(fontSize: 12),
                        ),

                      ],
                    ),
                  ),
                  Row(
                    children: [
                      int.parse(snapshot.child('profit').value.toString())>0?
                        Icon(Icons.arrow_circle_up,color: Colors.green,)
                        :
                        Icon(Icons.arrow_circle_down,color: Colors.red,),
                      Text(
                        "Rs.${snapshot.child('profit').value.toString()}",
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),

                ],
              ),

            ],
          ),
        )
          :
        // container for buy transcation
         Container(
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            // borderRadius: BorderRadiusDirectional.only(
            //   topStart: Radius.circular(20),
            //   bottomEnd: Radius.circular(20),
            // ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(child:Text("B")
//                      Icon(Icons.arrow_forward_ios)
                      ),
                      SizedBox(width: 5,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${snapshot.child('stockName').value.toString()}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${snapshot.child('fullStockName').value.toString()}",
                            style: TextStyle(
                              fontSize: 10,),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.date_range),
                      Text(
                        "${snapshot.child('transcationDate').value.toString()}",
                        style: cardText,
                      ),
                    ],
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5,left: 25),
                    child: Text(
                      "${snapshot.child('quantity').value.toString()} Shares",
                      style: cardText,
                    ),
                  ),
                  Text(
                    "${snapshot.child('price').value.toString()} rs.",
                    style: cardText,
                  ),

                ],
              ),

            ],
          ),
        );


        },
        
      ),

    );
  }
}
