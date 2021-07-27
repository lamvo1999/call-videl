import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_chuyen_nganh/enum/user_state.dart';
import 'package:do_an_chuyen_nganh/modules/users.dart';
import 'package:do_an_chuyen_nganh/resources/auth_methods.dart';
import 'package:do_an_chuyen_nganh/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();

  OnlineDotIndicator({@required this.uid});

  @override
  Widget build(BuildContext context) {
    getColor(int state){
      switch (Utils.numtoState(state)){
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;

      }
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _authMethods.getUserStream(
        uid: uid
      ),
      builder: (context, snapshot){
        Users user;

        if(snapshot.hasData && snapshot.data.data() != null){
          user = Users.fromMap(snapshot.data.data());
        }

        return Container(
          height: 10,
          width: 10,
          margin: EdgeInsets.only(right: 8, top: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getColor(user?.state),
          ),
        );
      }
    );
  }
}
