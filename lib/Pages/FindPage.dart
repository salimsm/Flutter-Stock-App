import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_json_navigation/constant.dart';
import '../Widgets/NavigationDrawer.dart';

class FindPage extends StatefulWidget {
  const FindPage({Key? key}) : super(key: key);

  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  var userEmail = FirebaseAuth.instance.currentUser!.email;

  final firebaseDatabaseRef = FirebaseDatabase.instance.ref('stock');

  @override
  Widget build(BuildContext context) {
    final userName = NameExtract.extractUserNameFromEmail(userEmail!);
    final myStockRef = FirebaseDatabase.instance.ref('myStock').child(userName);
    final buyerTranscationRef = FirebaseDatabase.instance.ref('transcation').child(userName);

    final double spaceHeight = 10;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Search Page'),
        backgroundColor: appBarColor,
      ),
      drawer: NavigationDrawer(userName),
      body: FirebaseAnimatedList(
        query: firebaseDatabaseRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          return Container(
            width: double.infinity,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
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
                  children: [
                    CircleAvatar(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                      ),
                      radius: 17,
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
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quantity: ${snapshot.child('quantity').value.toString()}",
                          style: cardText,
                        ),
                        Text(
                          "Price: Rs.${snapshot.child('price').value.toString()}",
                          style: cardText,
                        ),
                        Text("_________________"),
                        Text(
                          "Total : Rs."
                          "${int.parse(snapshot.child('price').value.toString()) * (int.parse(snapshot.child('quantity').value.toString()))}",
                          style: cardText,
                        ),
                      ],
                    ),


                (snapshot.child('seller').value.toString() == userName)
                    ? Text("Your Stock")
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                                  onPressed: () {
                                    showDialog(
                                        context: (context),
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Are you sure you want to buy?"),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    var date = DateTime.now();
                                                    print(snapshot.key);
                                                    var dateTime = DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString();
                                                    // save data to myStock of Buyer
                                                    myStockRef.child(dateTime)
                                                        .set({
                                                      'quantity': snapshot
                                                          .child('quantity')
                                                          .value
                                                          .toString(),
                                                      "price": snapshot
                                                          .child('price')
                                                          .value
                                                          .toString(),
                                                      "stockName": snapshot
                                                          .child('stockName')
                                                          .value
                                                          .toString(),
                                                      "fullStockName": snapshot
                                                          .child(
                                                              'fullStockName')
                                                          .value
                                                          .toString(),
                                                      "transcationDate":
                                                          "${date.year}/${date.month}/${date.day}",
                                                      "status": "sold"
                                                    }).then((value) =>
                                                            print("done"));

                                                    //  update records of seller
                                                    updateRecord(
                                                        snapshot.key!,
                                                        snapshot
                                                            .child('seller')
                                                            .value
                                                            .toString());
                                                    //snapshot provided by FirebaseAnimatedList
                                                    var x =snapshot.child('sellingAllStock').value.toString();
                                                    if(x=="true"){
                                                      final ownerMyStockRef =
                                                      FirebaseDatabase.instance.ref('myStock').child(snapshot
                                                          .child('seller')
                                                          .value
                                                          .toString()).child(snapshot.child('keyOfMyStock').value.toString()).remove();
                                                      //ownerMyStockRef.remove();


                                                    }else{
                                                      final ownerMyStockRef = 
                                                      FirebaseDatabase.instance.ref('myStock').child(snapshot
                                                          .child('seller')
                                                          .value
                                                          .toString()).child(snapshot.child('keyOfMyStock').value.toString());
                                                      var qtySold =int.parse(snapshot.child('quantity').value.toString());
                                                      var total =int.parse(snapshot.child('totalStockSellerHas').value.toString());
                                                      var remaining = total - qtySold;
                                                      ownerMyStockRef.update({"quantity":"$remaining"});
                                                    }
                                                    // transcation of seller part from here
                                                    int qty =int.parse(snapshot.child('quantity').value.toString());
                                                    var  sp = int.parse(snapshot.child('price').value.toString());
                                                    var cp=    int.parse(snapshot.child('costPrice').value.toString());
                                                    int profit = (sp-cp)*qty;
                                                    print("cp=$cp and sp=$sp and profit is $profit");
                                                    final tranRef = FirebaseDatabase.instance.ref('transcation').child(snapshot
                                                        .child('seller')
                                                        .value
                                                        .toString());
                                                    tranRef.child('$dateTime').set({
                                                      'profit':profit,
                                                      'costPrice':cp,
                                                      'sellingPrice':sp,
                                                      'quantity':snapshot.child('quantity').value.toString(),
                                                      'stockName':snapshot.child('stockName').value.toString(),
                                                      'fullStockName':snapshot.child('fullStockName').value.toString(),
                                                      'transcationDate':getDate(),
                                                      'transcationType':'sell'
                                                    });
                                                    //transcation of buyer part from here similar to
                                                    // adding to myStock when buyer buys

                                                    buyerTranscationRef.child(dateTime)
                                                        .set({
                                                      'quantity': snapshot
                                                          .child('quantity')
                                                          .value
                                                          .toString(),
                                                      "price": snapshot
                                                          .child('price')
                                                          .value
                                                          .toString(),
                                                      "stockName": snapshot
                                                          .child('stockName')
                                                          .value
                                                          .toString(),
                                                      "fullStockName": snapshot
                                                          .child(
                                                          'fullStockName')
                                                          .value
                                                          .toString(),
                                                      "transcationDate":
                                                      "${date.year}/${date.month}/${date.day}",
                                                      'transcationType':'buy'
                                                      //  "status": "sold"
                                                    }).then((value) =>
                                                        print("done"));


                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Yes")),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("No"))
                                            ],
                                          );
                                        });
                                    print("55555 owner name");
                                    print(snapshot
                                        .child('seller')
                                        .value
                                        .toString());
                                  },
                                  icon: Icon(Icons.shopping_cart),
                                  label: Text("Buy")),
                        ],
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

  void updateRecord(String key, String user) {
    // remove data form stock node (form find page where all stock are listed for sell )
    final stockRef = FirebaseDatabase.instance.ref('stock').child(key);
    stockRef.remove();
    // remove data from post node (stock which are kept for sale of individual user)
    final sellerPostRef =
        FirebaseDatabase.instance.ref('post').child(user).child(key);
    sellerPostRef.remove();



  }
}
