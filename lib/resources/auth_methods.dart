import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_chuyen_nganh/constants/strings.dart';
import 'package:do_an_chuyen_nganh/enum/user_state.dart';
import 'package:do_an_chuyen_nganh/modules/message.dart';
import 'package:do_an_chuyen_nganh/modules/users.dart';
import 'package:do_an_chuyen_nganh/provider/image_upload_provider.dart';
import 'package:do_an_chuyen_nganh/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore  firestore = FirebaseFirestore .instance;

  static final CollectionReference _userCollection = firestore.collection(USER_COLLECTION);

  Users users = Users();
  StorageReference  _storageReference;

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser;
    return currentUser;
  }

  Future<Users> getUserDetails() async{
    User currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot = await _userCollection.doc(currentUser.uid).get();

    return Users.fromMap(documentSnapshot.data());
  }

  Future<Users> getUserDetailById(id) async{
    try{
      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
      return Users.fromMap(documentSnapshot.data());
    }catch(e) {
      print(e);
      return null;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential;
  }

  Future<bool> authenticateUser(UserCredential userCredential) async {
    User user = userCredential.user ;
    QuerySnapshot result = await firestore
        .collection(USER_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.documents;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(UserCredential userCredential) async {
    User currentUser = userCredential.user;
    String username = Utils.getUsername(currentUser.email);

    users= Users(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: username);

    firestore
        .collection(USER_COLLECTION)
        .doc(currentUser.uid)
        .set(users.toMap(users));
  }

  Future<bool> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      return true;
    }catch(e){
      return false;
    }
  }

  Future<List<Users>> fetchAllUsers(User currentUser) async {
    List<Users> userList = List<Users>();

    QuerySnapshot querySnapshot =
    await firestore.collection(USER_COLLECTION).getDocuments();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].documentID != currentUser.uid) {

        userList.add(Users.fromMap(querySnapshot.docs[i].data()));

      }
    }
    return userList;
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _userCollection.doc(userId).updateData({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _userCollection.document(uid).snapshots();

}


