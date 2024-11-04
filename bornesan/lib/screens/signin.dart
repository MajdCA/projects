import 'package:bornesan/screens/home_admin.dart';
import 'package:bornesan/screens/home_superadmin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bornesan/reusable_widgets/reusable_widget.dart';
import 'package:bornesan/screens/reset_password.dart';
import 'package:bornesan/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  Future<bool> isUserAdmin(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        final Map<String, dynamic>? userData =
            doc.data() as Map<String, dynamic>?; // Cast to the expected type
        final String userRole = userData?['role'] ?? '';
        // ...
        // Assuming 'role' is the field name
        // Check if the user's role is 'admin'
        return userRole.toLowerCase() == 'admin';
      }
      return false; // User not found in Firestore, assume not an admin
    } catch (error) {
      print("Error fetching user data: $error");
      return false; // Handle the error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(children: <Widget>[
              logoWidget("assets/images/lock2.png"),
              const SizedBox(
                height: 30,
              ),
              reusableTextField("Enter Your Email", Icons.person_outline, false,
                  _emailTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Password", Icons.lock_outline, true,
                  _passwordTextController),
              const SizedBox(
                height: 5,
              ),
              firebaseUIButton(context, "Sign In", () async {
                // Capture the context in a local variable
                BuildContext localContext = context;
                try {
                  final UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text,
                  );

                  final User? user = userCredential.user;

                  if (user != null) {
                    final bool isAdmin = await isUserAdmin(user.uid);

                    if (isAdmin) {
                      Navigator.push(
                        localContext, // Use the captured context
                        MaterialPageRoute(
                          builder: (localContext) => const HomeScreenuser(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        localContext, // Use the captured context
                        MaterialPageRoute(
                          builder: (localContext) => const HomeScreen(),
                        ),
                      );
                    }
                  } else {
                    // Handle authentication failure
                  }
                } catch (error) {
                  print("Error: $error");
                  // Handle authentication error
                }
              })
            ]),
          ),
        ),
      ),
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResetPassword())),
      ),
    );
  }
}
