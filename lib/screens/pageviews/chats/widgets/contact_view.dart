import 'package:do_an_chuyen_nganh/modules/contact.dart';
import 'package:do_an_chuyen_nganh/modules/users.dart';
import 'package:do_an_chuyen_nganh/provider/user_provider.dart';
import 'package:do_an_chuyen_nganh/resources/auth_methods.dart';
import 'package:do_an_chuyen_nganh/resources/chat_methods.dart';
import 'package:do_an_chuyen_nganh/screens/chatscreens/chat_screen.dart';
import 'package:do_an_chuyen_nganh/screens/pageviews/chats/widgets/last_message_container.dart';
import 'package:do_an_chuyen_nganh/widgets/cached_image.dart';
import 'package:do_an_chuyen_nganh/widgets/custom_tile.dart';
import 'package:do_an_chuyen_nganh/widgets/online_dot_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Users>(
      future: _authMethods.getUserDetailById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData){
          Users user = snapshot.data;

          return ViewLayout(contact: user);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },

    );
  }
}

class ViewLayout extends StatelessWidget {
  final Users contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            receiver: contact,
          )
        ),
      ),
      title: Text(
        contact?.name ?? "..",
        style: TextStyle(
            color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(
                uid: contact.uid,
            )
          ],
        ),
      ),
    );
  }
}

