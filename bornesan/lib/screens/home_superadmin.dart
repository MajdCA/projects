import 'package:bornesan/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bornesan/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:bornesan/utils/color_utils.dart';
import 'package:bornesan/reusable_widgets/reusable_widget.dart';

class HomeScreenuser extends StatefulWidget {
  const HomeScreenuser({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreenuser> {
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
              firebaseUIButton(context, "Add user", () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
              }),
              firebaseUIButton(
                context,
                "Sign out",
                () {
                  FirebaseAuth.instance.signOut().then((value) {
                    print("Signed Out");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  });
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
