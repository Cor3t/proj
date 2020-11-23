import 'package:flutter/material.dart';

class DirectionTimer extends StatefulWidget {
  final Function press;
  final String time;
  final String distance;
  final IconData icon;
  DirectionTimer({this.press, this.time, this.distance, this.icon});
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
              alignment: Alignment.centerLeft,
              height: 80,
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DirectionText(text1: widget.time, text2: 'm', size: 30),
                      DirectionText(
                          text1: widget.distance, text2: 'km', size: 15),
                    ],
                  ),
                  SizedBox(width: 90),
                  Icon(
                    widget.icon,
                    size: 45,
                    color: Colors.white,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DirectionText extends StatelessWidget {
  const DirectionText(
      {Key key,
      @required this.text1,
      @required this.text2,
      @required this.size})
      : super(key: key);

  final String text1;
  final String text2;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: text1, style: TextStyle(fontSize: size, color: Colors.black)),
      TextSpan(
          text: ' $text2',
          style: TextStyle(fontSize: size, color: Colors.black))
    ]));
  }
}
