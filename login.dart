import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healme/Pages/profile.dart';
import 'package:healme/Pages/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found for that email");
      } else if (e.code == "wrong-password") {
        print("Wrong password provided for that user.");
      } else {
        print(e.code);
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    //create the textfiled controller
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0, // Adjust the border width as needed
                    ),
                  ),
                  child: const Image(
                    image: AssetImage(
                        "/Users/henriquesampaio/flutterspace/healMe/healme/assets/images/healMeLogo.png"),
                    width: 130,
                    height: 130,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Welcome to healMe",
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Patient Login",
                style: TextStyle(fontSize: 44.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              //email textbox
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
              const SizedBox(height: 10),
              const Text("Don't remember your password?",
                  style: TextStyle(color: Colors.blue)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: Colors.green.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () async {
                    User? user = await loginUsingEmailPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        context: context);
                    print(user);
                    if (user != null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Profile()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "User does not exist or password is incorrect"),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                  width: double.infinity,
                  child: RawMaterialButton(
                    fillColor: Colors.green.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                    },
                    child: const Text(
                      "Create Account",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ))
            ],
          )),
    );
  }
}
