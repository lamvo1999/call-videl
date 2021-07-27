import 'package:do_an_chuyen_nganh/resources/auth_methods.dart';
import 'package:do_an_chuyen_nganh/screens/home_screen.dart';
import 'package:do_an_chuyen_nganh/utils/universal_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  AuthMethods _authMethods = AuthMethods();
  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Stack(
        children: <Widget>[
          Center(
              child: loginButton()
          ),
          isLoginPressed
              ? Center(
            child: CircularProgressIndicator(),
          )
              :Container()
        ],
      ),
    );
  }

  Widget loginButton() {
    return FlatButton(
      padding: EdgeInsets.all(35),
      child: Row(
        children: <Widget>[
          Image(
            image: AssetImage("images/gg.png"),
            width: 50,
            height: 50,
          ),
          SizedBox(width: 10,),
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: UniversalVariables.senderColor,
            child: Text(
              "Đăng Nhập Với Google",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.2),
            ),
          ),
        ],
      ),
      onPressed: () => performLogin(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  void performLogin(){
    print("tring to perform login");

    _authMethods.signInWithGoogle().then((UserCredential user) {
          print("something");
          if (user != null) {
            authenticateUser(user);
          } else {
            print("There was an error");
          }
        });
  }


  void authenticateUser(UserCredential user) {
    _authMethods.authenticateUser(user).then((isNewUser) {

      setState(() {
        isLoginPressed = false;
      });

      if (isNewUser) {
        _authMethods.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
                return HomeScreen();
              }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }));
      }
    });
  }
}