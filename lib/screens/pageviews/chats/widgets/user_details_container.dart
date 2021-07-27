import 'package:do_an_chuyen_nganh/modules/users.dart';
import 'package:do_an_chuyen_nganh/provider/user_provider.dart';
import 'package:do_an_chuyen_nganh/resources/auth_methods.dart';
import 'package:do_an_chuyen_nganh/screens/login_screen.dart';
import 'file:///D:/Ha%20Android/Flutter%20App/do_an_chuyen_nganh/lib/screens/pageviews/chats/widgets/shimmering_logo.dart';
import 'package:do_an_chuyen_nganh/widgets/appbar.dart';
import 'package:do_an_chuyen_nganh/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    signOut() async {
      final bool isLoggesOut = await AuthMethods().signOut();

      if(isLoggesOut) {

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          CustomAppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.maybePop(context),
              ),
              centerTitle: true,
              title: ShimmeringLogo(),
              actions: <Widget>[
                FlatButton(
                  onPressed: () =>  signOut(),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
          ),
          UserDetailsBody(),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider  = Provider.of<UserProvider>(context);
    final Users user = userProvider.getUser;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          CachedImage(
            user.profilePhoto,
            isRound: true,
            radius: 50,
          ),
          SizedBox(width: 15,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10,),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

