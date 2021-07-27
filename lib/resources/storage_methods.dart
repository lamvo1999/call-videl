import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_chuyen_nganh/constants/strings.dart';
import 'package:do_an_chuyen_nganh/modules/message.dart';
import 'package:do_an_chuyen_nganh/modules/users.dart';
import 'package:do_an_chuyen_nganh/provider/image_upload_provider.dart';
import 'package:do_an_chuyen_nganh/resources/chat_methods.dart';
import 'package:do_an_chuyen_nganh/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';


class StorageMethods{

  Users users = Users();
  StorageReference  _storageReference;

  Future<String> uploadImageStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now()
          .millisecondsSinceEpoch}');

      StorageUploadTask _storageUploadTask = _storageReference
          .putFile(image);

      var url1 = await (await _storageUploadTask.onComplete).ref.getDownloadURL();

      String url = url1.toString();

      return url;
    }catch (e){
      print(e);
      return null;
    }
  }


  void uploadImage({
    @required File image,
    @required String receiverId,
    @required String senderId,
    @required ImageUploadProvider imageUpfloadProvider})
    async {
      final ChatMethods chatMethods = ChatMethods();

      imageUploadProvider.setToLoading();

      String url = await uploadImageStorage(image);

      imageUploadProvider.setToIdle();

      chatMethods.setImageMsg(url, receiverId, senderId);


    }



}


