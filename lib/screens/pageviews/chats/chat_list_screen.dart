import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_chuyen_nganh/modules/contact.dart';
import 'package:do_an_chuyen_nganh/provider/user_provider.dart';
import 'package:do_an_chuyen_nganh/resources/chat_methods.dart';
import 'package:do_an_chuyen_nganh/screens/pageviews/chats/widgets/contact_view.dart';
import 'package:do_an_chuyen_nganh/screens/pageviews/chats/widgets/new_chat_buttons.dart';
import 'package:do_an_chuyen_nganh/screens/pageviews/chats/widgets/quiet.dart';
import 'package:do_an_chuyen_nganh/screens/pageviews/chats/widgets/user_circle.dart';
import 'package:do_an_chuyen_nganh/utils/universal_variables.dart';
import 'package:do_an_chuyen_nganh/widgets/skype_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: SkypeAppBar(
        title: UserCircle(),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/search_screen");
            },
          ),

          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _chatMethods.fetchContacts(
          userId: userProvider.getUser.uid,
        ),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            var docList = snapshot.data.docs;

            if(docList.isEmpty ){
              return QuietBox(
                heading: "This is where all the contacts are listed",
                subtitle:
                "Search for your friends and family to start calling or chatting with them",
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: docList.length,
              itemBuilder: (context, index){
                Contact contact = Contact.fromMap(docList[index].data());

                return ContactView(contact);
              },
            );
          }

          return Center(child: CircularProgressIndicator(),);
        }),
    );
  }
}
