import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../Widgets/NavigationDrawer.dart';
import '../constant.dart';

class AddBuySellPage extends StatefulWidget {
  const AddBuySellPage({Key? key}) : super(key: key);

  @override
  _AddBuySellPageState createState() => _AddBuySellPageState();
}

class _AddBuySellPageState extends State<AddBuySellPage> {
  final List<String> buysellList = ["BUY", "SELL"];
  String? initalValue = "BUY";
  String? initalValueStock = "";

  var userEmail = FirebaseAuth.instance.currentUser!.email;

  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<String> listStock=[];
  List<String> listStockFullName=[];
  List<int> listQuantity=[];
  List<String> listKey=[];
  List<int> listCostPrice =[];
  late String keyToSave;
  String fullStockName="";
  int quantityAvailable=0;
  late bool sellingAllStock;
  int costPrice=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userName = NameExtract.extractUserNameFromEmail(userEmail!);
    print('11111111111111111-  $userName');
    var myStockRef = FirebaseDatabase.instance.ref('myStock').child('$userName');
    print(myStockRef);
    print("init shtae called-------------------------------------------");
    myStockRef.once().then((event) {
      print("no of childeren in myStock/userName is   ${event.snapshot.children.length}");
      for (final child in event.snapshot.children) {
        print("22222222222222");
        print(child.key);
        listKey.add(child.key!);
        var symbol=child.child('stockName').value;

        var fullName = child.child('fullStockName').value;
        var quantityAvailable =child.child('quantity').value;
        var costPrice =child.child('price').value;
        print("................$symbol  and price is $costPrice");
        listCostPrice.add(int.parse(costPrice.toString()));

        listStock.add(symbol.toString());
       listStockFullName.add(fullName.toString());
        listQuantity.add(int.parse(quantityAvailable.toString()));
       print("here is ${symbol.toString()} and full name is ${fullName.toString()} ");
      }
      setState(() {

      });
 //     final myStockRef = FirebaseDatabase.instance.ref('myStock').child(userName);

      print(listStock);
    }, onError: (error) {
      // Error.
    });
  }
  @override
  Widget build(BuildContext context) {
    var userName = NameExtract.extractUserNameFromEmail(userEmail!);
    final postRef = FirebaseDatabase.instance.ref('post').child(
        userName);
    final stockRef = FirebaseDatabase.instance.ref('stock');


    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('SellPage'),
      ),

      drawer: NavigationDrawer(userName),
      body: Container(
        color: backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              SizedBox(height: 10),

              SizedBox(
                height: 80,

                  child:listStock.isEmpty?Center(child: Container(height:50,width:50,child: CircularProgressIndicator())): DropdownButtonFormField<String?>(
                    decoration: textDecoration.copyWith(hintText: "Choose Stock Name"),
                      items: listStock.map((e) => DropdownMenuItem(child: Text(e),value: e,)).toList(),
                      onChanged: (value){
                        setState(() {
                          initalValueStock = value;
                          int i=listStock.indexOf(initalValueStock!);
                          fullStockName = listStockFullName.elementAt(i);
                          quantityAvailable = listQuantity.elementAt(i);
                          keyToSave = listKey.elementAt(i);
                          costPrice = listCostPrice.elementAt(i);
                        });
                      }),
                ),
              Text("$fullStockName"),
              SizedBox(height: 2,),
              Text("Total Available: $quantityAvailable"),

              SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                controller: quantityController,
                decoration: textDecoration.copyWith(hintText: "Quantity"),
              ),
              SizedBox(height: 20),
              Text("You paid Rs.: $costPrice for each stock"),
              SizedBox(height: 2,),

              TextField(
                keyboardType: TextInputType.number,
                controller: priceController,
                decoration: textDecoration.copyWith(hintText: "Price"),
              ),
              SizedBox(height: 20),
              // SizedBox(
              //   height: 80,
              //   child: DropdownButtonFormField<String>(
              //       decoration: textDecoration.copyWith(
              //           hintText: "Buy or Sell"),
              //       items: buysellList.map((item) => DropdownMenuItem(
              //           value: item,
              //           child: Text("$item", style: TextStyle(fontSize: 22,),)))
              //           .toList(),
              //       onChanged: (value) {
              //         setState(() {
              //           initalValue = value;
              //         });
              //       }),
              // ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green
                  ),
                  onPressed: () {

                print("..........................................");
                print(initalValue);
                print(fullStockName);
                print(quantityAvailable);
                print(quantityController.text.toString());
                print(priceController.text.toString());
                if(int.parse(quantityController.text.toString())==0|| quantityController.text.toString().isEmpty){
                  showSnackBar(context,"Please enter valid quantity");
                }
                if(int.parse(priceController.text.toString())==0 || priceController.text.toString().isEmpty){
                  showSnackBar(context,"Please enter valid price");
                }

                if(int.parse(quantityController.text.toString())>quantityAvailable){
                  showSnackBar(context,"Please enter valid quantity");
                }
                if(int.parse(quantityController.text.toString())==quantityAvailable){
                  sellingAllStock=true;
                }else{
                  sellingAllStock=false;
                }
                var dateTime =DateTime.now()
                    .millisecondsSinceEpoch
                    .toString();
                postRef.child(dateTime).set({
                  'quantity': quantityController.text,
                  "price": priceController.text,
                  "stockName":initalValueStock,
                  "fullStockName":fullStockName,
                  "transcationDate":"",
                  "status":"unsold",
                  "sellingAllStock":sellingAllStock,
                  "totalStockSellerHas":quantityAvailable,
                  "keyOfMyStock":keyToSave,
                  "costPrice":costPrice

                }).then((value) => print("done"));
                stockRef.child(dateTime).set({
                  "seller":userName,
                  'quantity': quantityController.text,
                  "price": priceController.text,
                  "buyOrSell": initalValue,
                  "stockName":initalValueStock,
                  "fullStockName":fullStockName,
                  "status":"unsold",
                  "sellingAllStock":sellingAllStock,
                  "totalStockSellerHas":quantityAvailable,
                  "keyOfMyStock":keyToSave,
                  "costPrice":costPrice


                }).then((value) => print("done"));
                  showSnackBar(context,"Task completed");
                quantityController.text="";
                priceController.text="";

              }, child: Text("Save")),

            ],
          )),


    );
  }
}
