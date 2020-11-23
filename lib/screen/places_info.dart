import 'package:flutter/material.dart';

class PlacesInfo extends StatelessWidget {
  final String title;
  final Function press;
  final Widget button1;
  final Widget button2;
  PlacesInfo({this.title, this.press, this.button1, this.button2});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 140,
          decoration: BoxDecoration(
              color: Colors.grey[350], borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.w500)),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    button1,
                    SizedBox(width: 10),
                    button2
                  ],
                ),
              )
            ],
          )),
    ));
  }
}
