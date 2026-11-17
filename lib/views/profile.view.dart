import 'package:flutter/material.dart';
import '../model/userdata.dart';
import '../model/userpost.dart';
import '../model/usercomment.dart';
import 'postlist.dart';

/// Post details screen: the post, its buttons, the comments, and a box
/// for adding a new comment.
class ProfileView extends StatefulWidget {
  const ProfileView({super.key, required this.userPost});
  final Userpost userPost;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final Userdata userdata = Userdata();
  final TextEditingController commentController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    commentController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void sendComment() {
    final text = commentController.text.trim();
    if (text.isEmpty) return; // ignore blank comments

    setState(() {
      userdata.addComment(widget.userPost, text); // adds and saves
    });
    commentController.clear();

    // Scroll down so the new comment is visible.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget commentsHeader(Userpost userPost) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 2, color: Colors.grey.shade300),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text('${userPost.numcomments}'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text('All Comments',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      );

  Widget userpostdetails(Usercomment c) => Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(c.commenterImg),
              radius: 18,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
             Container(
  padding: const EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: Colors.grey.shade200,
    borderRadius: BorderRadius.circular(15),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(c.commenterName, style: nametxtStyle),
      const SizedBox(height: 4),
      Text(c.commentContent),
    ],
  ),
),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(c.commentTime),
                      const SizedBox(width: 15),
                      const Text('Like'),
                      const SizedBox(width: 15),
                      const Text('Reply'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget commentBox() => SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(userdata.myUserAccount.img),
                radius: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: commentController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => sendComment(),
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: sendComment,
                icon: const Icon(Icons.send, color: Colors.blue),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final userPost = widget.userPost;
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                userline(userPost),
                postimage(userPost),
                buttons(userPost, () => setState(() {})),
                commentsHeader(userPost),
                if (userPost.comments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No comments yet. Be the first to comment!'),
                  ),
                ...userPost.comments.map(userpostdetails),
                const SizedBox(height: 10),
              ],
            ),
          ),
          commentBox(),
        ],
      ),
    );
  }
}