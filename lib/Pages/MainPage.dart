import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets/NavigationDrawer.dart';
import '../constant.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}



final numberS =TextStyle(fontSize: 20);
final textS =TextStyle(fontSize: 10);

class _MainPageState extends State<MainPage> {
  var userEmail = FirebaseAuth.instance.currentUser!.email;
  int totalInvest = 0;
  int noStock = 0;
  int totalCompany = 0;
  List<dynamic> detail = [];
  int totalProfit =0;
  int totalSold=0;

  @override
  void initState() {
    super.initState();
    detail.clear();




    var userName = NameExtract.extractUserNameFromEmail(userEmail!);


    final referenceTotal =
        FirebaseDatabase.instance.ref('myStock').child(userName);
    referenceTotal.once().then((event) {
      for (final child in event.snapshot.children) {
        var price = child.child('price').value;
        var quantity = child.child('quantity').value;
        noStock = noStock + int.parse(quantity.toString());
        var stockName = child.child('stockName').value;
        totalCompany++;
        var total =
            int.parse(price.toString()) * int.parse(quantity.toString());
        totalInvest = totalInvest + total;
        print("total-------------- $totalInvest  $noStock   $totalCompany");
      }
     // setState(() {});
      print(detail);
    }, onError: (error) {
      // Error.
    });
    // for total profit and sold amount
    final transRef =
    FirebaseDatabase.instance.ref('transcation').child(userName);
    transRef.once().then((event) {
      for (final child in event.snapshot.children) {
        if(child.child("transcationType").value.toString()=="sell"){
          var profit = child.child('profit').value;
          print("profit is .......................$profit");
          var sold = child.child('sellingPrice').value;
          totalProfit = totalProfit + int.parse(profit.toString());
          totalSold = totalSold + int.parse(sold.toString());

        }
        }
      setState(() {});
      print(detail);
    }, onError: (error) {
      // Error.
    });

  }

  final double spaceHeight = 20;

  @override
  Widget build(BuildContext context) {
    var userName = NameExtract.extractUserNameFromEmail(userEmail!);
    final firebaseDatabaseRef =
        FirebaseDatabase.instance.ref('myStock').child(userName);
    final referenceTotal =
        FirebaseDatabase.instance.ref('myStock').child(userName);
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('MainPage'),
      ),
      drawer: MainPageNavigationDrawer(userName),
      body: Column(
        children: [
          Container(
            height: 170,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: (totalInvest == null)
                ? CircularProgressIndicator()
                : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: Text("$totalProfit", style: numberS ),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Text("Overall Profit", style: textS )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: Text("${noStock}", style: numberS ),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Text("Total Units", style: textS )
                      ],
                    ),

                  ],
                ),
                Divider(
                  color: Colors.black,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    Column(
                      children: [
                        Text("$totalSold", style: numberS),
                        Text("Sold Amount", style: textS),
                      ],
                    ),
                    Column(
                      children: [
                        Text("${totalInvest}", style: numberS),
                        Text("Current Amount(Rs.)", style: textS),
                      ],
                    )
                  ],
                ),
                Divider(
                  color: Colors.black,
                ),
                Column(
                  children: [
                    Text("${totalInvest}", style: numberS),
                    Text("Total Investment(Rs.)", style: textS),
                  ],
                )

              ],
            ),
          ),
          SizedBox(height: 5,),
          Text("My Stocks",style: TextStyle(fontSize: 15),),
          Expanded(
            child: FirebaseAnimatedList(
              query: firebaseDatabaseRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return Container(
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
                              Icon(Icons.arrow_forward_ios),
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
                //ListTile(
                //title: Text(snapshot.child('price').value.toString()),
                //);
              },
            ),
          ),
        ],
      ),
    );
  }
}
