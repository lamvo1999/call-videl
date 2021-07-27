import 'package:do_an_chuyen_nganh/screens/callscreen/pickup/pickup_layout.dart';
import 'package:do_an_chuyen_nganh/screens/pageviews/logs/widgets/floating_column.dart';
import 'package:do_an_chuyen_nganh/screens/pageviews/logs/widgets/log_list_container.dart';
import 'package:do_an_chuyen_nganh/utils/universal_variables.dart';
import 'package:do_an_chuyen_nganh/widgets/skype_appbar.dart';
import 'package:flutter/material.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: SkypeAppBar(
          title: "Calls",
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, "/search_screen"),
            ),
          ],
        ),
        floatingActionButton: FloatingColumn(),
        body: Padding(
          padding: EdgeInsets.only(left: 15),
          child: LogListContainer(),
        ),
      ),
    );
  }
}