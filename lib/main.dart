import 'package:do_an_chuyen_nganh/provider/image_upload_provider.dart';
import 'package:do_an_chuyen_nganh/provider/user_provider.dart';
import 'package:do_an_chuyen_nganh/resources/auth_methods.dart';
import 'package:do_an_chuyen_nganh/screens/home_screen.dart';
import 'package:do_an_chuyen_nganh/screens/login_screen.dart';
import 'package:do_an_chuyen_nganh/screens/search_screen.dart';
import 'package:do_an_chuyen_nganh/utils/universal_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Skype Clone',
        initialRoute: '/',
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: UniversalVariables.blackColor,
          scaffoldBackgroundColor: UniversalVariables.blueColor,
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {

  AuthMethods _firebaseMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseMethods.getCurrentUser(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if(snapshot.hasData){
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}


