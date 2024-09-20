import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PostCard extends StatefulWidget {
  String title;
  String location;
  String imageUrl;
  String category;
  double rating;
  String post_id;
  PostCard({
    Key? key,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.post_id,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/details_screen",
            arguments: widget.post_id);
      },
      borderRadius: BorderRadius.circular(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            maxWidth: 260,
            maxHeight: 325,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue, width: 2.0),
          ),
          margin: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1.0,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  height: 214,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      // Wrap the title and location with Expanded widget
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15, // Adjust the font size as desired
                              fontFamily:
                                  'Montserrat', // Set the desired font family
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.pin_drop,
                                color: Colors.blue,
                              ),
                              Text(
                                widget.location,
                                style: const TextStyle(
                                  fontSize:
                                      15, // Adjust the font size as desired
                                  fontFamily:
                                      'Montserrat', // Set the desired font family
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    RatingBarIndicator(
                      itemSize: 30,
                      rating: widget.rating,
                      itemBuilder: (context, index) {
                        return const Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 246, 188, 41),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}