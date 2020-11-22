import 'package:flutter/material.dart';

class DirectionTimer extends StatefulWidget {
  final Function press;
  final String text;
  DirectionTimer({this.press, this.text});
  @override
  _DirectionTimerState createState() => _DirectionTimerState();
}

class _DirectionTimerState extends State<DirectionTimer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        height: 80,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(30)),
                child: FlatButton(
                    padding: EdgeInsets.all(5),
                    onPressed: widget.press,
                    child: Icon(Icons.arrow_back_ios_rounded, size: 35),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            SizedBox(width: 30),
            Container(
              height: 80,
              child: Center(
                  child: RichText(
                      text: TextSpan(children: [
                TextSpan(text: widget.text, style: TextStyle(fontSize: 20)),
                TextSpan(text: ' km', style: TextStyle(fontSize: 20))
              ]))),
            )
          ],
        ),
      ),
    );
  }
}
