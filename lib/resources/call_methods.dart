import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_chuyen_nganh/constants/strings.dart';
import 'package:do_an_chuyen_nganh/modules/call.dart';

class CallMethods {
  final CollectionReference callColection =
      Firestore.instance.collection(CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callColection.doc(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNoDialledMap = call.toMap(call);

      await callColection.doc(call.callerId).set(hasDialledMap);
      await callColection.doc(call.receiverId).set(hasNoDialledMap);
      return true;
    }catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try{
      await callColection.doc(call.callerId).delete();
      await callColection.doc(call.receiverId).delete();
    }catch(e) {
      print(e);
      return false;
    }
  }


}