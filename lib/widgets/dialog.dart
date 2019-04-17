import 'package:flutter/material.dart';

class TwoOptionsDialog extends StatelessWidget {

  final String first;
  final VoidCallback firstOnTap;
  final String second;
  final VoidCallback secondOnTap;

  TwoOptionsDialog({Key key, this.first, this.second, this.firstOnTap, this.secondOnTap}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            GestureDetector(
              child: Text(first),
              onTap: firstOnTap,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            GestureDetector(
              child: Text(second),
              onTap: secondOnTap,
            ),
          ],
        ),
      ),
    );
  }

}