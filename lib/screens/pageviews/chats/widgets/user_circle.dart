import 'package:do_an_chuyen_nganh/provider/user_provider.dart';
import 'file:///D:/Ha%20Android/Flutter%20App/do_an_chuyen_nganh/lib/screens/pageviews/chats/widgets/user_details_container.dart';
import 'package:do_an_chuyen_nganh/utils/universal_variables.dart';
import 'package:do_an_chuyen_nganh/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class UserCircle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: UniversalVariables.blackColor,
        builder: (context) => UserDetailsContainer(),
        isScrollControlled: true,
      ),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: UniversalVariables.separatorColor,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                Utils.getInitials(userProvider.getUser.name),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: UniversalVariables.lightBlueColor,
                  fontSize: 13,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: UniversalVariables.blackColor, width: 2),
                    color: UniversalVariables.onlineDotColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}