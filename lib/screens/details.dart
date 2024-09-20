import 'package:akherhaga/screens/NewExWidget.dart';
import 'package:akherhaga/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class Details_Screen extends StatefulWidget {
  const Details_Screen({super.key});

  @override
  State<Details_Screen> createState() => _Details_ScreenState();
}

class _Details_ScreenState extends State<Details_Screen> {
  @override
  var user = FirebaseAuth.instance.currentUser;
  List users_list = [];
  void addNewExpense(
      {String? comment,
      required String user_id,
      double? rating,
      required String user_email,
      required String user_name,
      required String post_id}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(post_id)
        .collection('Comment')
        .add({
          'comment text': comment,
          'rating': rating,
          'user_id': user_id,
          'user_email': user_email,
          'user_name': user_name
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

    Navigator.of(context).pop();
  }

  void showNewExpenseBottomSheet(BuildContext ctx, String post_id_) {
    showModalBottomSheet(
        context: ctx,
        builder: (sheetContext) {
          print('show modal');
          return NewExWidget(callBackFunc: addNewExpense, post_id: post_id_);
        });
  }

  // Future<String> get_user_name(String user_id) async {
  //   String name = 'undefined';
  //   var result = await FirebaseFirestore.instance
  //       .collection('Users')
  //       .where('userId', isEqualTo: user_id)
  //       .get()
  //       .then((QuerySnapshot QS) {
  //     QS.docs.forEach((doc) {
  //       name = doc["username"];
  //     });
  //   });
  //   return name;
  // }

  Widget build(BuildContext context) {
    final post_id_ = ModalRoute.of(context)!.settings.arguments;

    var commentsInstance = FirebaseFirestore.instance
        .collection('posts')
        .doc(post_id_ as String?)
        .collection('Comment');
    var myStream = commentsInstance.snapshots();
    // final AverageRating_instance = FirebaseFirestore.instance
    //     .collection('posts')
    //     .doc('0j28pN0UPyWH95eDbHWG');
    double average_rating = 0;
    // var ay7aga = AverageRating_instance.get().then(
    //   (DocumentSnapshot doc) {
    //     final data = doc.data() as Map;
    //     print('average fl awel');
    //     average_rating = data['average_rating'];
    //     print(average_rating);
    //   },
    //   onError: (e) => print("Error getting document: $e"),
    // );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Center(
            child: Text(
              "Details",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(post_id_ as String?)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var averagedoc = snapshot.data;
              average_rating = averagedoc!['average_rating'];
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 270,
                        width: 500,
                        child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            margin: EdgeInsets.all(10),
                            child: Image.network(
                              averagedoc["imageUrl"],
                              fit: BoxFit.fill,
                            )),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            averagedoc["name"].toString(),
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          RatingBarIndicator(
                              itemSize: 30,
                              rating: average_rating,
                              itemBuilder: (context, index) {
                                return const Icon(Icons.star,
                                    color: Colors.black);
                              })
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 25,
                                color: Color.fromARGB(255, 30, 134, 219),
                              ),
                              Text(
                                averagedoc["location"],
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.blue),
                              )
                            ],
                          ),
                          Text(
                            averagedoc["type"],
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        averagedoc["description"],
                        style: GoogleFonts.georama(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Recommendation ",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        averagedoc["recommendation"],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Text(
                          "Comments ",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Icon(Icons.comment)
                      ]),
                      SizedBox(
                        height: 5,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: myStream,
                        builder: (ctx, strSnapshot) {
                          if (strSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          var myDocuments = strSnapshot.data!.docs;
                          // var result = get_user_name('2wXImbz5mwSimFYy83v7vOw5MXm2');
                          //  print(result.toString());
                          if (strSnapshot.hasData &&  myDocuments.isEmpty) {
                            print('salamo 3alekom');
                            return Container(
                              height:80,
                              width:double.infinity,
                              decoration: BoxDecoration(
  color: Color.fromARGB(255, 149, 152, 155),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
                              
                                
                                  child: Center(
                                    child: Text(
                                      "No Comments Yet",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                
                            );
                          } else {
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              itemBuilder: (itemCtx, index) {
                                var document = myDocuments[index].data() as Map;
                           
                                  return Card(
                                    child: ListTile(
                                      // leading: CircleAvatar(
                                      //   backgroundColor: const Color(0xff764abc),
                                      //   child: Icon(
                                      //     Icons.account_circle,
                                      //     size: 25,
                                      //   ),
                                      // ),
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.person_3_outlined,
                                            size: 25,
                                          ),
                                          Text(
                                            document['user_name'],
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        document['comment text'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            color: Color.fromARGB(
                                                255, 26, 25, 25)),
                                      ),
                                      // trailing: IconButton(
                                      //   iconSize: 50,
                                      //   onPressed: () {
                                      //     ScaffoldMessenger.of(context)
                                      //         .showSnackBar(
                                      //             SnackBar(content: Text('Icon ')));
                                      //   },
                                      //   icon: Icon(
                                      //     Icons.delete,
                                      //   ),
                                      // ),
                                    ),
                                  );
                                
                              },
                              itemCount: myDocuments.length,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 25),
                      Text(
                        'Rate The post',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(height: 17),
                      Center(
                        child: RatingBar.builder(
                            itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20),
                            onRatingUpdate: (value) async {
                              if (user == null) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('cancel')),
                                          TextButton(
                                              onPressed: () {
                                                print('dakhal el login');
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LoginScreen()));
                                              },
                                              child: const Text('Sign In'))
                                        ],
                                        title: const Text('Sign In'),
                                        content: const Text(
                                            'Sign In to Post , Comment and Review'),
                                        titlePadding: const EdgeInsets.only(
                                            top: 20, left: 20),
                                        contentPadding:
                                            const EdgeInsets.all(20),
                                      );
                                    });
                              } else {
                                print('value put');
                                print(value);
                                // Here I add the rating record
                                CollectionReference posts =
                                    await FirebaseFirestore.instance
                                        .collection('posts');
                                posts
                                    .doc(post_id_ as String?)
                                    .collection('rating')
                                    .doc(user?.uid)
                                    .set(
                                        {'rating': value, 'user_id': user?.uid})
                                    .then((value) => print("rating Added"))
                                    .catchError((error) =>
                                        print("Failed to add rating: $error"));

                                // here I shall count the number of record and field value of avarege rating
                                int number_of_documents = 0;
                                double sum_of_ratings = 0;
                                var samy = await posts
                                    .doc(post_id_ as String?)
                                    .collection('rating')
                                    .get()
                                    .then((QuerySnapshot QS) {
                                  QS.docs.forEach((doc) {
                                    print('index');
                                    number_of_documents =
                                        number_of_documents + 1;
                                    num value = doc["rating"];
                                    print(value);
                                    sum_of_ratings = (sum_of_ratings + value);
                                  });
                                });

                                await posts.doc(post_id_ as String?).update({
                                  'average_rating':
                                      sum_of_ratings / number_of_documents
                                }).then((value) {
                                  print("sum_of_ratings");
                                  print(sum_of_ratings);
                                  print("number_of_documents");

                                  print(number_of_documents);
                                }).catchError((error) =>
                                    print("Failed to add rating: $error"));
                              }
                            }),
                      ),
                      SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () {
                          print('pressed');

                          if (user == null) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('cancel')),
                                      TextButton(
                                          onPressed: () {
                                            print('dakhal el login');
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen()));
                                          },
                                          child: const Text('Sign In'))
                                    ],
                                    title: const Text('Sign In'),
                                    content: const Text(
                                        'Sign In to Post , Comment and Review'),
                                    titlePadding: const EdgeInsets.only(
                                        top: 20, left: 20),
                                    contentPadding: const EdgeInsets.all(20),
                                  );
                                });
                          } else if (user != null) {
                            print(user);
                            showNewExpenseBottomSheet(context, post_id_!);
                          }
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Comment'),
                              SizedBox(width: 5),
                              Icon(Icons.add_comment_rounded, size: 24.0)
                            ]),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 55),
                            backgroundColor: Colors.blue,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}
