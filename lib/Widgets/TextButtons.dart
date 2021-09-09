import 'package:firebasechat/Pages/SignUp.dart';
import 'package:flutter/material.dart';

class RegisterNow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.grey[800]),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: Text(
              'Register now',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                  color: Colors.grey[800]),
            ))
      ],
    );
  }
}

class ForgetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () {},
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.grey[800]),
            )),
        SizedBox(
          width: size.width * .05,
        )
      ],
    );
  }
}
