
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import 'MainPage.dart';
import 'RegisterPage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isButtonPressed =false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.green.shade200,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Login Page"),
        backgroundColor: Colors.green,
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
                child: GestureDetector(
                  child: Text("Register"),
                  onTap: () {
                     Navigator.of(context).push(
                         MaterialPageRoute(builder: (context) => RegisterPage()));
                  },
                )),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            //  ------------ email textfield     ----------
            TextFormField(
              decoration: textDecoration,
              controller: emailController,
            ),

            SizedBox(height: 20),

            //  ------------ password textfield     ----------
            TextFormField(
              obscureText: true,
              decoration: textDecoration.copyWith(hintText:'Password'),
            controller: passwordController,
            ),

            SizedBox(height: 20),

            //  ------------ login button     ----------
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 70) ,
              ),
              child: Text("Login"),
              onPressed: () {
                if(emailController.text.toString().isEmpty || passwordController.text.toString().isEmpty){
                  showSnackBar(context, "Please, enter email or password..");
                  return;
                }

                  signInWithEmailAndPassword(context,emailController.text.toString(), passwordController.text.toString());
              },
            ),
            SizedBox(height: 20),
            Text("No Account yet, Create by taping on Register"),
          ],
        ),
      ),

    );
  }
}


Future signInWithEmailAndPassword(BuildContext context,String email, String password) async{
  try{
    var result = await FirebaseAuth.instance.signInWithEmailAndPassword(email:email,password: password);
    print("result is $result" );
print('-----------------------------');
    print("result.user === ${result.user}");
    print('----------------');
    print("result.user === ${result.user!.email}");

    //.then((value){
      //print(result);
      return Navigator.of(context).push(MaterialPageRoute(builder:(context)=>MainPage()));
   // });

  }catch(e){
    print(e.toString());
    return null;
  }
}

