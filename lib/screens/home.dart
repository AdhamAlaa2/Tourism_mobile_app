import 'package:akherhaga/screens/login_screen.dart';
import 'package:akherhaga/widgets/post_card.dart';
import 'package:akherhaga/widgets/search_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_bar.dart';

class Home extends StatelessWidget {
  var user = FirebaseAuth.instance.currentUser;
  Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var postsInstance = FirebaseFirestore.instance.collection('posts');
    var stream = postsInstance.snapshots();
    return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (user != null)
                        ? StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Users')
                                .doc(user!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              var averagedoc = snapshot.data;

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xff764abc),
                                  child:
                                      Icon(Icons.person_2_outlined, size: 24.0),
                                ),
                                title: Text(
                                  averagedoc!["username"].toString(),style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                                ),
                                subtitle: Text(averagedoc["email"].toString(),style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),),
                              );
                            },
                          )
                        : ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xff764abc),
                              child: Icon(Icons.person_2_outlined, size: 24.0),
                            ),
                            title: Text('Hi User !', 
                               style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                            
                            ),
                            subtitle: Text('Nice to see you here' ,style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),),
                          ),
                  ],
                ),
              ),
              InkWell(
                child: ListTile(
                  leading: (user == null)
                      ? const Icon(Icons.login_rounded)
                      : const Icon(Icons.logout_rounded),
                  title: Text(user != null ? 'Logout' : 'Sign In'),

                  onTap: () {
                    if (user != null) {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushAndRemoveUntil<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => LoginScreen(),
                          ),
                          (route) =>
                              false, //if you want to disable back feature set to false
                        );
                      });
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    }
                  },

                  // onTap: () {

                  //   if (user != null) {
                  //     FirebaseAuth.instance.signOut().then((value) {
                  //       // Navigator.push(
                  //       //     context,
                  //       //     MaterialPageRoute(
                  //       //         builder: (context) => LoginScreen()));

                  //       Navigator.pushAndRemoveUntil<dynamic>(
                  //         context,
                  //         MaterialPageRoute<dynamic>(
                  //           builder: (BuildContext context) => LoginScreen(),
                  //         ),
                  //         (route) =>
                  //             false, //if you want to disable back feature set to false
                  //       );
                  //     });
                  //   } else {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => LoginScreen()));
                  //   }
                  // },
                ),
              )
            ],
          ),
        ),
        // body: SingleChildScrollView(
        // child:
        body:
            // Container(
            //     padding: const EdgeInsets.all(30),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text('Hi there 👋', style: TextStyle(fontSize: 20.0)),
            //         const Text(
            //           'Take a virtual museum tour',
            //           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            //         ),
            //         const SearchBox(),
            FilterChipExample(),
        //const Categories(),
        // Container(
        //   margin: const EdgeInsets.only(top: 30),
        //   child: Center(
        //     child: StreamBuilder<QuerySnapshot>(
        //   stream: stream,
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState ==
        //         ConnectionState.waiting) {
        //       return LoadingScreen();
        //     }
        //     var posts = snapshot.data!.docs;
        //     return ListView.builder(
        //         itemBuilder: (context, index) {
        //           var document = posts[index].data() as Map;
        //           return PostCard(
        //               title: document['name'],
        //               location: document['location'],
        //               imageUrl: document['imageUrl'],
        //               category: document['type']);
        //         },
        //         itemCount: posts.length);
        //   },
        // )
        //           ),
        //     )
        //   ],
        // )),
        // ),
        bottomNavigationBar: const BottomBar());
  }
}

class FilterChipExample extends StatefulWidget {
  const FilterChipExample({super.key});

  @override
  State<FilterChipExample> createState() => _FilterChipExampleState();
}

class _FilterChipExampleState extends State<FilterChipExample> {
  int? _value = null;
  List<String> options = [
    'Restaurant',
    'Wonder',
    'Museum',
    'Hotels',
    'beach',
    'club'
  ];

  @override
  Widget build(BuildContext context) {
    var type;
    if (_value == 0) {
      type = 'Restaurant';
    }
    if (_value == 1) {
      type = 'Wonder';
    }
    if (_value == 2) {
      type = 'Museum';
    }
    if (_value == 3) {
      type = 'Hotels';
    }
    if (_value == 4) {
      type = 'beach';
    }
    if (_value == 5) {
      type = 'club';
    }

    var postInstance = FirebaseFirestore.instance
        .collection("posts")
        .where("type", isEqualTo: type);
    var myStream = postInstance.snapshots();

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.all(30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Hi there 👋', style: TextStyle(fontSize: 20.0)),
            const Text(
              'Take a virtual museum tour',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            const SearchBox(),
            StreamBuilder<QuerySnapshot>(
                stream: myStream,
                builder: (ctx, strSnapshot) {
                  if (strSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var myDocuments = strSnapshot.data!.docs;
                  return
                      // SingleChildScrollView(
                      //   child:
                      Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List<Widget>.generate(
                            options.length,
                            (int index) {
                              return ChoiceChip(
                                label: Text(options[index]),
                                selected: _value == index,
                                onSelected: (bool selected) {
                                  setState(() {
                                    _value = selected ? index : null;
                                  });
                                },
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      SizedBox(height: 19),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        itemBuilder: (itemCtx, index) {
                          var document = myDocuments[index].data() as Map;
                          return PostCard(
                              title: document['name'],
                              location: document['location'],
                              imageUrl: document['imageUrl'],
                              rating: double.parse(
                                  document['average_rating'].toString()),
                              post_id: myDocuments[index].id,
                              category: document['type']);
                        },
                        itemCount: myDocuments.length,
                      )
                    ],
                  );
                  // ,
                  // );
                })
          ])),
    ));
  }
}
