import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:healme/Pages/login.dart';
import 'package:healme/Pages/start.dart';
import 'package:healme/Pages/woundRegister.dart';
import 'package:healme/Widgets/appbar_widget.dart';
import 'package:healme/Widgets/profile_widget.dart';
import 'package:healme/Widgets/status_widget.dart';
import 'package:healme/Pages/edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../User/user.dart';

enum _SelectedTab { home, camera, shop }

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  var _selectedTab = _SelectedTab.home;

  Future<User1>? userDetails;

  @override
  void initState() {
    super.initState();
    // Initialize the userDetails Future in initState
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userDetails = getUserDetails(user.email!);
    }
  }

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
    if (i == 1) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const woundRegisterPage()));
    } else if (i == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Profile()));
    }
  }

  List<String> docIDs = [];
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              print(element.reference);
              docIDs.add(element.reference.id);
            }));
  }
  
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    getDocId();
    var anim = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 500),
    );

    return FutureBuilder<User1>(
      future: userDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData) {
          return Text("No data");
        } else {
          User1 userData = snapshot.data!;
          return Scaffold(
            //appBar: buildAppBar(context),
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath: "",
                  onClicked: () async {},
                ),
                const SizedBox(height: 24),
                buildName(userData),
                const SizedBox(height: 24),
                Center(child: buildChatButton()),
                const SizedBox(height: 24),
                StatusWidget(sex: userData.sex, age: userData.age,),
                const SizedBox(height: 48),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green.shade300,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                      ),
                      child: const Text('Sign Out')),
                )
              ],
            ),

            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DotNavigationBar(
                margin: const EdgeInsets.only(left: 10, right: 10),
                currentIndex: _SelectedTab.values.indexOf(_selectedTab),
                dotIndicatorColor: Colors.white,
                unselectedItemColor: Colors.grey[300],
                splashBorderRadius: 50,
                // enableFloatingNavBar: false,
                onTap: _handleIndexChanged,
                items: [
                  /// Home
                  DotNavigationBarItem(
                    icon: const Icon(Icons.home),
                    selectedColor: Colors.green.shade300,
                  ),

                  /// Camera
                  DotNavigationBarItem(
                    icon: const Icon(Icons.camera_alt_rounded),
                    selectedColor: Colors.green.shade300,
                  ),

                  /// Shop
                  DotNavigationBarItem(
                    icon: const Icon(Icons.medical_information),
                    selectedColor: Colors.green.shade300,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

 Widget buildName(User1 userData) {
    return Column(
      children: [
        Text(
          userData.firstName + " " + userData.lastName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome to HealMe',
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget buildChatButton() => ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green.shade300,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      child: const Text('Chat with a physician'));

  Future<User1> getUserDetails(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    final userData = snapshot.docs.map((e) => User1.fromSnapshot(e)).single;
    return userData;
  }
}
