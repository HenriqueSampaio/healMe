import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healme/Pages/login.dart';
import 'package:healme/Pages/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return const Profile();
              } else {
                return const LoginScreen();
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
}
}
/**/

/*StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
          if(snapshot.hasData){
            return Profile();
          } else{
            return LoginScreen();
          }
      },
    )*/

/*return Scaffold(
      body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return LoginScreen();
              } else {
                return LoginScreen();
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );*/