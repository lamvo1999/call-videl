import 'dart:math';

import 'package:do_an_chuyen_nganh/constants/strings.dart';
import 'package:do_an_chuyen_nganh/modules/call.dart';
import 'package:do_an_chuyen_nganh/modules/log.dart';
import 'package:do_an_chuyen_nganh/modules/users.dart';
import 'package:do_an_chuyen_nganh/resources/call_methods.dart';
import 'package:do_an_chuyen_nganh/resources/local_db/repository/log_repository.dart';
import 'package:do_an_chuyen_nganh/screens/callscreen/call_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CallUtils{
  static final CallMethods callMethods = CallMethods();

  static dial({Users from, Users to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if(callMade) {

      LogRepository.addLogs(log);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        )
      );
    }


  }
}