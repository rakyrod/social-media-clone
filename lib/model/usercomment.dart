class Usercomment {
  final String commenterImg;
  final String commenterName;
  final String commentTime;
  final String commentContent;

  Usercomment({
    required this.commenterImg,
    required this.commenterName,
    required this.commentTime,
    required this.commentContent,
  });

  // Used to save the comment on the device.
  Map<String, dynamic> toJson() => {
        'commenterImg': commenterImg,
        'commenterName': commenterName,
        'commentTime': commentTime,
        'commentContent': commentContent,
      };

  factory Usercomment.fromJson(Map<String, dynamic> json) => Usercomment(
        commenterImg: json['commenterImg'] as String,
        commenterName: json['commenterName'] as String,
        commentTime: json['commentTime'] as String,
        commentContent: json['commentContent'] as String,
      );
}