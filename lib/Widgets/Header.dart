import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final String subTitle;

  const Header({Key key, @required this.title, @required this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0, left: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w500,
                letterSpacing: 2),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            subTitle,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w300,
              wordSpacing: 2.0,
            ),
          )
        ],
      ),
    );
  }
}
