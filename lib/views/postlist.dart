import 'package:flutter/material.dart';
import '../model/userdata.dart';
import '../model/userpost.dart';
import 'profile.view.dart';
var nametxtStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 14);

Future<void> gotoPage(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

Widget userline(Userpost userPost) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CircleAvatar(
            backgroundImage: AssetImage(userPost.userimg),
            radius: 20,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userPost.username, style: nametxtStyle),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(userPost.time),
                const Text('.'),
                const Icon(Icons.group, size: 15, color: Colors.grey),
              ],
            ),
          ],
        ),
      ],
    );

Widget postimage(Userpost userPost) => Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [Text(userPost.postcontent)]),
          const SizedBox(height: 15),
          Container(
            height: 350,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(userPost.postimg),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );

/// Like / Comment / Share row. [onChanged] lets the parent rebuild after a Like.
Widget buttons(Userpost userPost, VoidCallback onChanged) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Divider(color: Colors.grey),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: userPost.isLiked ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  userPost.isLiked = !userPost.isLiked;
                  onChanged();
                },
                icon: const Icon(Icons.thumb_up, size: 20),
                label: const Text('Like'),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble, size: 20),
                label: const Text('Comment'),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                onPressed: () {},
                icon: const Icon(Icons.share, size: 20),
                label: const Text('Share'),
              ),
            ],
          ),
        ),
      ],
    );

/// The list of posts. This is a SLIVER, so it goes straight inside the
/// CustomScrollView in socialmedia.dart (no ListView inside a ListView).
class Postlist extends StatefulWidget {
  const Postlist({super.key, required this.userdata});
  final Userdata userdata;

  @override
  State<Postlist> createState() => _PostlistState();
}

class _PostlistState extends State<Postlist> {
  Widget showPost(Userpost userPost) => Column(
        children: [
          userline(userPost),
          postimage(userPost),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${userPost.numcomments} Comments'),
                const SizedBox(width: 15),
                Text('${userPost.numshare} Shares'),
              ],
            ),
          ),
          buttons(userPost, () => setState(() {})),
          SizedBox(height: 10, child: Container(color: Colors.grey)),
          const SizedBox(height: 15),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final posts = widget.userdata.userList;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final userPost = posts[index];
          return InkWell(
            onTap: () async {
              await gotoPage(context, ProfileView(userPost: userPost));
              // Coming back: refresh so the new comment count shows.
              if (mounted) setState(() {});
            },
            child: showPost(userPost),
          );
        },
        childCount: posts.length,
      ),
    );
  }
}