
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'friend.dart';
import 'usercomment.dart';
import 'userpost.dart';
import 'account.dart';

// Shown in the app bars so the last name is visible on every screen.
const String ownerLastName = 'Ednilan';

class Userdata {
  // One shared copy, so the feed and post screen see the same comments.
  Userdata._internal();

  static final Userdata _instance = Userdata._internal();

  factory Userdata() => _instance;

  static const String _prefsKey = 'saved_comments_v1';

  List<Userpost> userList = [
    Userpost(
      userimg: 'lib/assets/sunbat.jpg',
      username: 'John Doe',
      time: '2 hrs ago',
      postcontent: 'Had a great day at the beach!',
      postimg: 'lib/assets/cake.png',
      numshare: '5',
      isLiked: false,
      comments: [
        Usercomment(
          commenterImg: 'lib/assets/diana.webp',
          commenterName: 'Jane Smith',
          commentTime: '1 hr ago',
          commentContent: 'Looks fun!',
        ),
        Usercomment(
          commenterImg: 'lib/assets/ethan.jpg',
          commenterName: 'Mike Johnson',
          commentTime: '30 mins ago',
          commentContent: 'Wish I was there!',
        ),
        Usercomment(
          commenterImg: 'lib/assets/fem2.jpeg',
          commenterName: 'Emily Davis',
          commentTime: '15 mins ago',
          commentContent: 'Great photo!',
        ),
      ],
    ),
    Userpost(
      userimg: 'lib/assets/cake.png',
      username: 'Jane Smith',
      time: '3 hrs ago',
      postcontent: 'Loving the new cafe in town.',
      postimg: 'lib/assets/fem2.jpeg',
      numshare: '3',
      isLiked: true,
      comments: [
        Usercomment(
          commenterImg: 'lib/assets/female pic.jpg',
          commenterName: 'John Doe',
          commentTime: '2 hrs ago',
          commentContent: 'We should go together!',
        ),
      ],
    ),
    Userpost(
      userimg: 'lib/assets/run.jpeg',
      username: 'Mike Johnson',
      time: '5 hrs ago',
      postcontent: 'Just finished a 10k run!',
      postimg: 'lib/assets/run.jpeg',
      numshare: '7',
      isLiked: false,
      comments: [],
    ),
    Userpost(
      userimg: 'lib/assets/ethan.jpg',
      username: 'Johnson Stewart',
      time: '5 hrs ago',
      postcontent: 'Just finished a 10k run!',
      postimg: 'lib/assets/run.jpeg',
      numshare: '7',
      isLiked: false,
      comments: [],
    ),
  ];

  List<Friend> friendList = [
    Friend(img: 'lib/assets/fem2.jpeg', name: 'Alice'),
    Friend(img: 'lib/assets/female pic.jpg', name: 'Bob'),
    Friend(img: 'lib/assets/diana.webp', name: 'Diana'),
    Friend(img: 'lib/assets/ethan.jpg', name: 'Ethan'),
    Friend(img: 'lib/assets/fiona.jpeg', name: 'Fiona'),
  ];

  Account myUserAccount = Account(
    name: 'Nicole A. Ednilan',
    email: 'n.ednilan.549690@umindanao.edu.ph',
    img: 'lib/assets/profile.png',
    numFollowers: '10 Million',
    numPosts: '350',
    numFollowing: '500',
    numFriends: '400',
  );

  // Adds a comment from the logged-in user and saves it.
  void addComment(Userpost post, String text) {
    final trimmedText = text.trim();

    if (trimmedText.isEmpty) return;

    post.comments.add(
      Usercomment(
        commenterImg: myUserAccount.img,
        commenterName: myUserAccount.name,
        commentTime: 'Just now',
        commentContent: trimmedText,
      ),
    );

    saveComments();
  }

  // Saves every post's comments on the device.
  Future<void> saveComments() async {
    try {
      final data = {
        for (var i = 0; i < userList.length; i++)
          '$i': userList[i].comments.map((c) => c.toJson()).toList(),
      };

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_prefsKey, jsonEncode(data));
    } catch (e) {
      // Saving failed; comments remain visible until the app closes.
    }
  }

  // Loads saved comments before the app starts.
  Future<void> loadComments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);

      if (raw == null) return;

      final decoded = jsonDecode(raw) as Map<String, dynamic>;

      for (var i = 0; i < userList.length; i++) {
        final saved = decoded['$i'];

        if (saved is List) {
          userList[i].comments = saved
              .map(
                (e) => Usercomment.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList();
        }
      }
    } catch (e) {
      // Nothing saved yet, or saved data could not be read.
    }
  }
}
