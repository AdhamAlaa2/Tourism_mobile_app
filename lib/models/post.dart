

import 'package:akherhaga/models/Categories.dart';

class Post {
  final String postId;
  final String name;
  final String location;
  final String description;
  final String imageURL;
  final String userId;
  final Category? type;
  final double rating;
  final double avgRating;

  Post({
    required this.postId,
    required this.name,
    required this.type,
    required this.location,
    required this.description,
    required this.imageURL,
    required this.userId,
    this.rating = 0.0,
    required this.avgRating,
  });
}
