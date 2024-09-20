import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/post_card.dart';
import 'loading_screen.dart';

class FilteredPostsScreen extends StatelessWidget {
  FilteredPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final postsInstance = FirebaseFirestore.instance.collection('posts');
    final stream = postsInstance.snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("Results for: '${args['searchParam']}'"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingScreen();
                }
                if (!snapshot.hasData) {
                  return LoadingScreen();
                }
                var posts = snapshot.data!.docs;
                final filteredPosts = posts
                    .where((element) => element['name'].toString().toLowerCase()
                        .toString()
                        .contains(args['searchParam'].toString().toLowerCase()))
                    .toList();
                return ListView.builder(
                  itemBuilder: (context, index) {
                    var document = filteredPosts[index].data() as Map;
                    var docId = filteredPosts[index].id;
                    return PostCard(
                        post_id: docId,
                        title: document['name'],
                        location: document['location'],
                        imageUrl: document['imageUrl'],
                        category: document['type'],
                        rating: double.parse(
                            document['average_rating'].toString()));
                  },
                  itemCount: filteredPosts.length,
                );
              }),
        ),
      ),
    );
  }
}
