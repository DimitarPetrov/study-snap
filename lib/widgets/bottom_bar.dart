import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: BottomAppBar(
        child: Row(
          children: <Widget>[

          ],
        ),
        shape: CircularNotchedRectangle(),
      ),
    );
  }

}