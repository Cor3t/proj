import 'package:flutter/material.dart';

class BuildFloatingActionButton extends StatelessWidget {
  final Function press;
  const BuildFloatingActionButton({
    this.press,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipOval(
          child: Material(
              elevation: 20,
              color: Colors.white,
              child: InkWell(
                splashColor: Colors.grey,
                child: SizedBox(
                    width: 56, height: 56, child: Icon(Icons.my_location)),
                onTap: press,
              ))),
    );
  }
}
