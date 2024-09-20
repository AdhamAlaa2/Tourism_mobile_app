class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName; // Add the display name field
  final String content;
  final DateTime dateTime;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.dateTime,
  });
}
