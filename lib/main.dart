import 'package:akherhaga/screens/details.dart';
import 'package:akherhaga/screens/filtered_posts_screen.dart';
import 'package:akherhaga/screens/home.dart';
import 'package:akherhaga/screens/loading_screen.dart';
import 'package:akherhaga/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

//import 'screens/login_screen.dart';
//import 'screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _intialized = false;
  bool _error = false;
  //
  void intializeflutterfire() async {
    try {
      await Firebase.initializeApp();
      print('awel khatwa ');
      setState(() {
        _intialized = true;
      });
      print('el intialization et3ayare = 1');
    } catch (e) {
      setState(() {
        print('el intialization et3ayare = 0');
        _error = true;
      });
    }
  }

  @override
  void initState() {
    intializeflutterfire();
    super.initState();
  }

  Widget ShowAppropriateScreen() {
    if (_intialized) {
      {
        //return const LoginScreen();

        var user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          print('user authenticated fl main');
          return Home();
          // return Details_Screen();
        } else {
          print('user is not authenticated fl main');
          return const LoginScreen();
        }
      }
    } else if (_error) {
      print('el error b 1');
      return const Text('Error');
    } else {
      return const LoadingScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourism App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShowAppropriateScreen(),
      routes: {
        '/details_screen': (context) => const Details_Screen(),
        '/filteredPosts': (context) => FilteredPostsScreen(),
      },
    );
  }
}
