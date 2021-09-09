import 'package:firebasechat/Services/Auth.dart';
import 'package:firebasechat/Services/Controller.dart';
import 'package:firebasechat/Services/database.dart';
import 'package:firebasechat/Helper/helperFunctions.dart';
import 'package:firebasechat/Widgets/Header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool userNameExist = false;
  bool userEmailExist = false;
  bool active = false;
  DatabaseMethods databaseMethods = DatabaseMethods();
  var _key = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final userNameCtrl = TextEditingController();

  void _submit() async {
    final _auth = Provider.of<AuthBase>(context, listen: false);

    if (_key.currentState.validate()) {
      final userNameValid =
          await databaseMethods.userNameExists(userNameCtrl.text.trim());
      final userEmailValid =
          await databaseMethods.userEmailExists(emailCtrl.text.trim());

      if (userNameValid) {
        if (userEmailValid) {
          if (_key.currentState.validate()) {
            setState(() {
              active = true;
              userNameExist = false;
              userEmailExist = false;
            });
            await _auth
                .signUpWithEmailAndPassword(
                    emailCtrl.text.trim(), passCtrl.text.trim())
                .whenComplete(() {
              _auth.updateUser(userNameCtrl.text.trim());

              // creating a map object so we can upload it on firebase
              Map<String, String> userInfoMap = {
                "name": userNameCtrl.text.trim(),
                "email": emailCtrl.text.trim()
              };

              // saving name and email in sharedPreference for later use
              HelperFunctions.saveUserEmailSharedPreference(
                  emailCtrl.text.trim());
              HelperFunctions.saveUserNameSharedPreference(
                  userNameCtrl.text.trim());

              // uploading userInfo to firebase
              databaseMethods.uploadUserInfo(
                  userInfoMap, userNameCtrl.text.trim());
            }).whenComplete(() {
              // saving that userLoggedIn
              HelperFunctions.saveUserLoggedInSharedPreference(true);

              // send user to home after successfully SigningUp
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
        } else {
          setState(() {
            userEmailExist = true;
            _key.currentState.validate();
            userEmailExist = false;
          });
        }
      } else {
        setState(() {
          userNameExist = true;
          _key.currentState.validate();
          userNameExist = false;
        });
      }
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
                    Header(title: 'Sign Up', subTitle: 'Create a new account'),
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.1,
                        ),

                        /// text form field
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Form(
                            key: _key,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    prefixIcon: Icon(
                                      Icons.drive_file_rename_outline,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide(
                                            color: Colors.deepPurpleAccent)),
                                  ),
                                  controller: userNameCtrl,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Enter the Username';
                                    } else if (userNameExist) {
                                      return 'Username already exist, try another';
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
                                      return 'Please Enter the email';
                                    } else if (userEmailExist) {
                                      return 'Email already exist, try another';
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
                                        borderRadius: BorderRadius.circular(24),
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
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),

                        /// SignUp button
                        ElevatedButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32)),
                              minimumSize: Size(280, 50)),
                          onPressed: _submit,
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
