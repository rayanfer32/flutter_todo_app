import 'package:flutter/material.dart';
import 'package:flutter_todo/widgets.dart';

import 'package:flutter_todo/models/task.dart';
import '../database_helper.dart';
import '../models/task.dart';
import '../models/todo.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();


  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";



  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;


  @override
  void initState() {
    if (widget.task != null) {
      //Set visibility to true
      _contentVisible = true;


      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
      _taskId = widget.task.id;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }


  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }


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
                              focusNode: _titleFocus,
                            onSubmitted: (value) async {
                            print("Field Value: $value");

                            // Check if field is not empty
                            if (value != "") {
                              // Check if task if null
                              if (widget.task == null) {
                                Task _newTask = Task(title: value);

                                _taskId = await _dbHelper.insertTask(_newTask);
                                setState(() {
                                  _contentVisible = true;
                                  _taskTitle = value;
                                });

                                print("added new task $_taskId");
                              } else {
                                await _dbHelper.updateTaskTitle(_taskId,value);

                                print("$value updated");

                              }
                            }
                            _descriptionFocus.requestFocus();
                          },
                          controller: TextEditingController()
                            ..text = _taskTitle,
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
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        focusNode: _descriptionFocus,
                          onSubmitted: (value) async {
                          if(value != ""){
                            if(_taskId != 0){
                              await _dbHelper.updateTaskDescription(_taskId, value);
                              _taskDescription = value;
                            }
                          }

                            _todoFocus.requestFocus();
                          },
                          controller: TextEditingController()..text = _taskDescription,
                          decoration: InputDecoration(
                              hintText: "Enter Description for the task",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 24,
                              ))),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getTodos(_taskId),
                        builder: (context, snapshot) {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if(snapshot.data[index].isDone == 0){
                                        await _dbHelper.updateTodoDone(snapshot.data[index].id, 1);
                                      }
                                      else{
                                        await _dbHelper.updateTodoDone(snapshot.data[index].id, 0);
                                      }

                                      setState(() {

                                      });
                                    },
                                    child: TodoWidget(
                                      text: snapshot.data[index].title,
                                      isDone: snapshot.data[index].isDone == 0
                                          ? false
                                          : true,
                                    ),
                                  );
                                }),
                          );
                        }),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            margin: EdgeInsets.only(
                              right: 12,
                            ),
                            child: Icon(Icons.check_box_outline_blank_rounded,
                                color: Colors.black26),
                            decoration: BoxDecoration(
                              // color: Color(0xFF7349FE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController()..text = "",
                              focusNode: _todoFocus,
                                onSubmitted: (value) async {
                                  // Check if field is not empty
                                  if (value != "") {
                                    // Check if task if null
                                    if (_taskId != 0) {
                                      Todo _newTodo = Todo(
                                        title: value,
                                        isDone: 0,
                                        taskId: _taskId,
                                      );

                                      await _dbHelper.insertTodo(_newTodo);

                                      print("Todo has been added");
                                      setState(() {});
                                      _todoFocus.requestFocus();
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter Todo Item",
                                  border: InputBorder.none,
                                )),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(

                  bottom: 12,
                  right: 24,
                  child: GestureDetector(
                    onTap: () async {
                      if(_taskId != 0){
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }

                    },
                    child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [Colors.pinkAccent, Colors.pink],
                            begin: Alignment(0, -1),
                          ),
                        ),
                        child: Container(
                            child: Icon(Icons.delete_forever,
                                size: 32, color: Colors.white))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
