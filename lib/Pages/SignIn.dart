import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasechat/Services/Auth.dart';
import 'package:firebasechat/Services/Controller.dart';
import 'package:firebasechat/Services/database.dart';
import 'package:firebasechat/Helper/helperFunctions.dart';
import 'package:firebasechat/Widgets/Header.dart';
import 'package:firebasechat/Widgets/TextButtons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool active = false;

  DatabaseMethods databaseMethods = DatabaseMethods();

  var _key = GlobalKey<FormState>();

  final emailCtrl = TextEditingController();

  final passCtrl = TextEditingController();

  _login() async {
    final _authLogin = Provider.of<AuthBase>(context, listen: false);

    QuerySnapshot snapshot;

    // Checking that user didn't left TextFormField empty.
    if (_key.currentState.validate()) {
      setState(() {
        active = true;
      });
      // Here first we get user detail by his email then we save his details to snapShot.
      // In snapShot we have user's all detail so we save username from snapShot to HelperFunction.
      databaseMethods.getUserByUserEmail(emailCtrl.text.trim()).then((val) {
        snapshot = val;
        HelperFunctions.saveUserNameSharedPreference(
            snapshot.docs[0].get("name"));
      });
      // Saving email in HelperFunction.
      HelperFunctions.saveUserEmailSharedPreference(emailCtrl.text.trim());

      await _authLogin
          .signInWithEmailAndPassword(
              emailCtrl.text.trim(), passCtrl.text.trim())
          .whenComplete(() {
        // We saved info in HelperFunction that user is loggedIn.
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        // user successfully loggedIn so we will send his to home screen.
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyControl()),
            (route) => false).whenComplete(() {
          setState(() {
            active = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: active
          ? Loader()
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    Header(
                        title: 'Sign In',
                        subTitle: 'Chat app created by Aziz Khan.'),
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// text form field
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Form(
                            key: _key,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'E-mail',
                                    prefixIcon: Icon(
                                      Icons.drive_file_rename_outline,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide(
                                            color: Colors.deepPurpleAccent)),
                                  ),
                                  controller: emailCtrl,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Enter the UserName';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: size.height * 0.015,
                                ),
                                TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(
                                        Icons.drive_file_rename_outline,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          borderSide: BorderSide(
                                              color: Colors.deepPurpleAccent)),
                                    ),
                                    controller: passCtrl,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter the Password';
                                      } else if (value.length < 6) {
                                        return 'Password length should be more than 6';
                                      } else {
                                        return null;
                                      }
                                    })
                              ],
                            ),
                          ),
                        ),

                        /// login button
                        SizedBox(
                          height: size.height * 0.075,
                        ),
                        ElevatedButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32)),
                              minimumSize: Size(280, 50)),
                          onPressed: _login,
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ),

                        /// Register
                        SizedBox(
                          height: size.height * 0.04,
                        ),

                        RegisterNow(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
