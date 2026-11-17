import 'package:flutter/material.dart';
import 'package:flutter_application_7/model/userdata.dart';
import 'package:flutter_application_7/views/friendlist.dart';
import 'package:flutter_application_7/views/infoheader.dart';
import 'package:flutter_application_7/views/mainheader.dart';
import 'package:flutter_application_7/views/postlist.dart';

class Socialmedia extends StatefulWidget {
  const Socialmedia({super.key});

  @override
  State<Socialmedia> createState() => _SocialmediaState();
}

class _SocialmediaState extends State<Socialmedia> {
  // The shared copy, so comments added on a post screen show up here too.
  Userdata userdata = Userdata();

  var followTxtStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ownerLastName),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      // ListView bug fix: ONE CustomScrollView scrolls the whole page.
      // Before, ListViews were nested inside other scrolling widgets.
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Mainheader(userdata: userdata),
                Infoheader(userdata: userdata),
                Friendlist(userdata: userdata),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(children: [Text('Posts', style: followTxtStyle)]),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Postlist(userdata: userdata),
        ],
      ),
    );
  }
}