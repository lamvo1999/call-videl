import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_chuyen_nganh/constants/strings.dart';
import 'package:do_an_chuyen_nganh/modules/contact.dart';
import 'package:do_an_chuyen_nganh/modules/message.dart';
import 'package:do_an_chuyen_nganh/modules/users.dart';
import 'package:flutter/cupertino.dart';



class ChatMethods {
  static final FirebaseFirestore  firestore = FirebaseFirestore .instance;

  final CollectionReference _messageCollection = firestore.collection(MESSAGE_COLLECTION);
  final CollectionReference _userCollection = firestore.collection(USER_COLLECTION);

  Future<void> addMessageToDb(Message message, Users sender, Users receiver) async {
    var map = message.toMap();

    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    return await _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContactsDocument({String of, String forContact}) =>
  _userCollection
      .doc(of)
      .collection(CONTACTS_COLLECTION)
      .doc(forContact);

  addToContacts({String senderId, String receiverId}) async{
    Timestamp currentTime = Timestamp.now();

    await addToSenderContact(senderId, receiverId, currentTime);
    await addToReceiverContact(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContact(
      String senderId,
      String receiverId,
      currentTime,
      ) async {
    DocumentSnapshot senderSnapshot =  await getContactsDocument(of: senderId, forContact: receiverId).get();

    if(!senderSnapshot.exists){
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
      .set(receiverMap);
    }
  }

  Future<void> addToReceiverContact(
      String senderId,
      String receiverId,
      currentTime,
      ) async {
    DocumentSnapshot receiverSnapshot =  await getContactsDocument(of: receiverId, forContact: senderId).get();

    if(!receiverSnapshot.exists){
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  setImageMsg(String url, String receiverId, String senderId) async {
    Message _message;
    _message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image'
    );

    var map = _message.toImageMap();

    await _messageCollection
        .doc(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

   _messageCollection
        .doc(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) => _userCollection
      .doc(userId)
      .collection(CONTACTS_COLLECTION)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
  @required String senderId,
    @required String receiverId,
}) =>
      _messageCollection
      .doc(senderId)
      .collection(receiverId)
      .orderBy('timestamp')
      .snapshots();

}


