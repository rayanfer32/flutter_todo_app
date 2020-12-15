import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String desc;

  TaskCardWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.only(bottom: 20),
        child: Stack(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                title ?? "{No title}",
                style: TextStyle(
                    color: Color(0xff211551),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              Text(
                desc ?? "No Description",
                style: TextStyle(
                  color: Color(0xff211111),
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
            ]),
          ],
        ));
  }
}

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isDone;

  TodoWidget({this.text, @required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              margin: EdgeInsets.only(
                right: 12,
              ),
              child: isDone
                  ? Icon(Icons.check_box_rounded,
                      color: Colors.deepPurpleAccent)
                  : Icon(Icons.check_box_outline_blank_rounded,
                      color: Colors.black26),
              decoration: BoxDecoration(
                // color: Color(0xFF7349FE),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Flexible(
              child: Text(
                text ?? "{Unnamed Todo}",
                style: TextStyle(
                  color: isDone ? Colors.deepPurple : Colors.black26,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ));
  }
}

class suggestionsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Sugestions bar.."));
  }
}


class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
