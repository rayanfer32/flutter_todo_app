import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo/screens/taskpage.dart';
import '../widgets.dart';
import '../database_helper.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 24,
                          bottom: 32,
                        ),
                        child: Image.asset('assets/ui/go_grocery_logo.png',
                            width: 64, height: 64),
                      ),
                      Text(
                        "Grocer Note.",
                        style: TextStyle(
                            color: Color(0xff213551),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,),
                      )
                    ],
                  ),
                  Expanded(
                    child: Consumer<DatabaseHelper>(
                      builder: (context, tasks, child) => FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getTasks(),
                        builder: (context, snapshot) {
                          return ScrollConfiguration(
                              behavior: NoGlowBehavior(),
                            child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TaskPage(
                                                task: snapshot.data[index],
                                              ))).then(
                                    (value) {
                                      setState(() {});
                                    },
                                  );
                                },
                                child: TaskCardWidget(
                                  id: snapshot.data[index].id,
                                  title: snapshot.data[index].title,
                                  desc: snapshot.data[index].description,
                                ),
                              );
                            },
                          ),
                          );
                        }),
                  ),
                  ),
                ],
              ),
              Positioned(
                bottom: 12,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskPage(task: null)),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blueAccent, Colors.blue],
                            begin: Alignment(0, -1),
                          ),
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                          child: Icon(Icons.add_rounded,
                              size: 32, color: Colors.white))),
                ),
              ),
            ],
          )),
    ));
  }
}
