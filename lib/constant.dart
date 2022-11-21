import 'package:flutter/material.dart';

InputDecoration textDecoration = InputDecoration(
  hintText: "Email",
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
  ),
);

String getDate(){
  var date = DateTime.now();
  return "${date.year}/${date.month}/${date.day}";
}

class NameExtract {

  static String extractUserNameFromEmail(String user){
    var indexOfSymbol = user.indexOf("@");
    var userName = user.replaceRange(indexOfSymbol, user.length,"");
    print("new name = $userName");
    return userName;
  }

}

final Color appBarColor = Colors.green.shade800;
final Color backgroundColor =Colors.green.shade200;
final Color cardColor = Colors.lightGreen.shade100;
final TextStyle cardText = TextStyle(fontSize: 14);
final TextStyle titleText =TextStyle(fontSize: 22,fontWeight: FontWeight.w800);

showSnackBar(BuildContext context,String msg){
  final snackBar = SnackBar(content: Text("$msg"));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}