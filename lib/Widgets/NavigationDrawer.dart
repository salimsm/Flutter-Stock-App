import 'package:flutter/material.dart';
import 'package:flutter_json_navigation/Pages/FindPage.dart';
import 'package:flutter_json_navigation/Pages/MyBuySellPage.dart';
import 'package:flutter_json_navigation/Pages/TranscationPage.dart';
import 'package:flutter_json_navigation/constant.dart';

import '../Pages/AddBuySellPage.dart';
import '../Pages/MainPage.dart';


class NavigationDrawer extends StatelessWidget {
  final String userName;
  const NavigationDrawer(this.userName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: ListView(

        children: [
          DrawerHeader(
            padding: EdgeInsets.all(0),
            child: Container(
                color: appBarColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 30,
                    ),
                    Text("${userName.toUpperCase()}",style: titleText,),
                  ],
                )),
          ),
          ListTile(leading: Icon(Icons.home),title: Text('Home',style: cardText,),
            onTap: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MainPage()));
            },),
          ListTile(leading: Icon(Icons.search),title: Text('Search Stock to buy',style: cardText,),
          onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> FindPage()));
          }
          ),
          ListTile(leading: Icon(Icons.add),title: Text('Sell your stock',style: cardText,),onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> AddBuySellPage()));

          },),
          ListTile(leading: Icon(Icons.border_all),title: Text('My stock for sell',style: cardText,),onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MyBuySellPage()));

          },),
          ListTile(leading: Icon(Icons.compare_arrows),title: Text('My Transcation',style: cardText,),onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TranscationPage()));

          },),

        ],
      ),
    );
  }
}



class MainPageNavigationDrawer extends StatelessWidget {
  final String userName;
  const MainPageNavigationDrawer(this.userName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(0),
            child: Container(
                color: appBarColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 30,
                    ),
                    Text("${userName.toUpperCase()}",style: titleText,),
                  ],
                )),
          ),
          ListTile(leading: Icon(Icons.home),title: Text('Home',style: cardText,),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MainPage()));
            },),
          ListTile(leading: Icon(Icons.search),title: Text('Search Stock to buy',style: cardText,),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FindPage()));
              }
          ),
          ListTile(leading: Icon(Icons.add),title: Text('Sell your stock',style: cardText,),onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddBuySellPage()));

          },),
          ListTile(leading: Icon(Icons.border_all),title: Text('My stock for sell',style: cardText,),onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyBuySellPage()));

          },),
          ListTile(leading: Icon(Icons.compare_arrows),title: Text('My Transcation',style: cardText,),onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TranscationPage()));

          },),

        ],
      ),
    );
  }
}
