import 'package:flutter/material.dart';
import 'package:flutter_todo/widgets.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 6,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Icon(Icons.arrow_back)),
                        ),
                        Expanded(
                            child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Task Title",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                        decoration: InputDecoration(
                            hintText: "Enter Description for the task",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                            ))),
                  ),
                  TodoWidget(text: "its my",isDone: true),
                  TodoWidget(text: "first todo", isDone: true),
                  TodoWidget(text: "second todo",isDone:false),
                  TodoWidget(text: "last todo",isDone: false),
                ],
              ),
              Positioned(
                bottom: 12,
                right: 24,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TaskPage()));
                  },
                  child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                          child: Icon(Icons.delete_forever,
                              size: 32, color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
