import 'package:flutter/material.dart';
import 'package:healme/User/user.dart';
import 'package:healme/utils/user_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //User1 user = UserPreferences.myUser;
  @override
  Widget build(BuildContext context) {
    return Container();/*Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {},
            isEdit: true,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Full Name',
            text: user.name,
            onChanged: (name) => user = user.copy(name:name),
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Email',
            text: user.email,
            onChanged: (email) => user = user.copy(email:email),
          ),
          const SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {
              UserPreferences.setUser(user);
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          )
        ],
      ),
    );*/

  }
}
