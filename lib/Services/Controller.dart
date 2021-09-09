import 'package:firebasechat/Pages/Home.dart';
import 'package:firebasechat/Pages/SignIn.dart';
import 'package:firebasechat/Services/Auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<MyUser>(
      stream: auth.onAuthChanged,
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.active) {
          MyUser user = snapShot.data;
          if (user == null) {
            return Provider<MyUser>.value(
              value: user,
              child: SignIn(),
            );
          }
          if (user.userId == null) {
            return Provider<MyUser>.value(
              value: user,
              child: SignIn(),
            );
          } else {
            return Provider<MyUser>.value(
              value: user,
              child: Home(),
            );
          }
        }
        return Loader();
      },
    );
  }
}

/// Loader class

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 100,
          width: 100,
          child: FlareActor(
            "assets/icons/loader_floating.flr",
            animation: "Loading",
          ),
        ),
      ),
    );
  }
}
