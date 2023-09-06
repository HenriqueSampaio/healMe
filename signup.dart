import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healme/Pages/login.dart';
import 'package:healme/Pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healme/Pages/start.dart';
import '../Widgets/appbar_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();
TextEditingController _firstNameController = TextEditingController();
TextEditingController _lastNameController = TextEditingController();

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  "Welcome to healMe",
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Create an account",
                  style: TextStyle(fontSize: 44.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Material(
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Email address",
                        prefixIcon: Icon(Icons.mail, color: Colors.black)),
                  ),
                ),
                const SizedBox(height: 24),

                //password textbox
                Material(
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock, color: Colors.black)),
                  ),
                ),
                const SizedBox(height: 24),
                //confirm password textbox
                Material(
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock, color: Colors.black)),
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                    width: double.infinity,
                    child: RawMaterialButton(
                      fillColor: Colors.green.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () {
                        if (confirmPasswordController.text.trim() ==
                            passwordController.text.trim()) {
                          if (confirmPasswordController.text.trim().length >
                              6) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => registerUser()));
                          }
                          else{
                            const Text("Password must be longer than 6 characters");
                          }
                        } else {
                          const Text("Passwords do not match");
                        }
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )),
                const SizedBox(height: 24),
                Center(
                    child: Row(
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                                child: CircularProgressIndicator()));

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ))
              ],
            )));
  }
}

//REGISTERING USER INFORMATION

class registerUser extends StatefulWidget {
  const registerUser({super.key});

  @override
  State<registerUser> createState() => _registerUserState();
}

class _registerUserState extends State<registerUser> {
  @override
  String dropdownValueSex = 'Male';
  DateTime dateTime = DateTime.now();
  Widget build(BuildContext context) {
    Null gender;
    int age = 0;
    return Scaffold(
        appBar: buildAppBar(context),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  "Welcome to healMe",
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Please fill in your information",
                  style: TextStyle(fontSize: 44.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Material(
                  child: TextField(
                    controller: _firstNameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "First name",
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                //Last name
                Material(
                  child: TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Last name",
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text("Birthday?"),
                //Birthday
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade300, // Set the button color
                    minimumSize:
                        Size(double.infinity, 48), // Stretch horizontally
                  ),
                  child: Text(
                    '${dateTime.year}/${dateTime.month}/${dateTime.day}',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                  onPressed: () async {
                    final date = await pickDate();
                    if (date == null) return;
                    setState(() => dateTime = date);
                    int calculateAge(DateTime birthday) {
                      DateTime currentDate = DateTime.now();
                      int a = currentDate.year - birthday.year;
                      if (currentDate.month < birthday.month ||
                          (currentDate.month == birthday.month &&
                              currentDate.day < birthday.day)) {
                        a--;
                      }
                      return age;
                    }
                    setState(() {age = calculateAge(dateTime);});
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey), // Set the border color
                    borderRadius:
                        BorderRadius.circular(8.0), // Set the border radius
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text("Sex: "),
                      SizedBox(width: 180),
                      DropdownButton<String>(
                        value: dropdownValueSex,
                        items: <String>['Male', 'Female']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValueSex = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const SizedBox(height: 24),
                SizedBox(
                    width: double.infinity,
                    child: RawMaterialButton(
                      fillColor: Colors.green.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () {
                        signUp(
                          _firstNameController.text.trim(),
                          _lastNameController.text.trim(),
                          passwordController.text.trim(),
                          emailController.text.trim(),
                          dropdownValueSex,
                          age,
                        );
                      },
                      child: const Text(
                        "Finish",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ))
              ],
            )));
  }

  Future signUp(String firstName, String lastName, String password, String email, String sex,
      int age) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());

    //add user details

    try {
      await FirebaseFirestore.instance.collection('users').add({
        'first name': firstName,
        'last name': lastName,
        'email': email,
        'sex': sex,
        'age': age,
        'password': password,
      });
    } catch (e) {
      print(e);
    }

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Home()));
  }

  //DATE PICKER
  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

  /*Future register() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    //add user details

    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
    });

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const Profile()));
  }*/
}
