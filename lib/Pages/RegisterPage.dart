import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constant.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.green.shade200,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.green,
        title: Text("Register Page"),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
                child: GestureDetector(
                  child: Text("Login"),
                  onTap: () {
                    Navigator.of(context).pop();
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
              controller :emailController,
                decoration: textDecoration,
                ),

            SizedBox(height: 20),

            //  ------------ password textfield     ----------
            TextFormField(
              decoration: textDecoration.copyWith(hintText: "Password"),
            obscureText: true,
            controller: passwordController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 70) ,
              ),
              child: Text("Register"),
              onPressed: () {
               registerWithEmailAndPassword(context,emailController.text.toString(), passwordController.text.toString());


              },
            ),

            SizedBox(height: 20),

            Text("Already have an Account, signin by taping on Login"),
          ],
        ),
      ),

    );
  }

  Future registerWithEmailAndPassword(BuildContext context, String email, String password) async{

    var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email:email, password:password);

    return Navigator.of(context).pop();

  }
}
