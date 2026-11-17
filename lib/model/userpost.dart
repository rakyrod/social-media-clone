import 'usercomment.dart';

class Userpost {
  final String userimg;
  final String username;
  final String time;
  final String postcontent;
  final String postimg;
  final String numshare;
  bool isLiked;

  /// Every post keeps its own list of comments.
  List<Usercomment> comments;

  Userpost({
    required this.userimg,
    required this.username,
    required this.time,
    required this.postcontent,
    required this.postimg,
    required this.numshare,
    required this.isLiked,
    required this.comments,
  });

  /// Always matches the comments that are really on the post.
  int get numcomments => comments.length;
}