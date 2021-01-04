import 'package:flutter/material.dart';
import 'package:flutter_todo/widgets.dart';

import 'package:flutter_todo/models/task.dart';
import 'package:provider/provider.dart';
import '../database_helper.dart';
import '../models/task.dart';
import '../models/todo.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'dart:convert';

List allProducts;

class SuggestionLoader extends SearchDelegate<String> {
  var recentQuery = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) { }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (allProducts == null) {
      return Text("failed");
    }

    final suggestionList = query.isEmpty ? recentQuery : allProducts;
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.eco),
        title: Text(suggestionList[index].name),
      ),
      itemCount: allProducts.length,
    );
  }
}

class TaskPage extends StatefulWidget {
  final Task task;

  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

// var _userInput = "";

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  final enterTodoItemController = TextEditingController();
  final enterTaskTitleController = TextEditingController();
  final enterTaskDescriptionController = TextEditingController();


  String _userInput = "";

  List loadToList(data) {
    allProducts = data;
  }

  Future<List<dynamic>> retrieveSuggestions() async {
    final json =
        DefaultAssetBundle.of(context).loadString('assets/products.json');
    final decoder = JsonDecoder();
    final data = decoder.convert(await json);

    return loadToList(data);

    // dynamic i;
    // int counter = 0;
    // for (i in data) {
    //   print(i);
    //   if (counter == 10) {
    //     break;
    //   } else {
    //     counter += 1;
    //   }
    // }
  }

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

    enterTaskTitleController..text = _taskTitle;
    if (_taskDescription == "") {
      final now = DateTime.now().toLocal().toString().substring(0,10);
      enterTaskDescriptionController..text = now;
      print(now);
    }
    else{
      enterTaskDescriptionController.text = _taskDescription;
    }
    retrieveSuggestions();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    enterTodoItemController.dispose();
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
                          onChanged: (value) async {
                            print("Field Value: $value");

                            // Check if field is not empty
                            if (value != "") {
                              // Check if task if null
                              if (_taskId == 0) {
                                Task _newTask = Task(title: value);

                                _taskId = await _dbHelper.insertTask(_newTask);
                                setState(() {
                                  _contentVisible = true;
                                  _taskTitle = value;
                                  enterTaskTitleController.selection = TextSelection.fromPosition(TextPosition(offset: enterTaskTitleController.text.length));
                                  _dbHelper.updateTaskDescription(_taskId, enterTaskDescriptionController.text);
                                });
                                // _contentVisible = true;
                                // _taskTitle = value;

                                print("added new task $_taskId");
                              } else {
                                await _dbHelper.updateTaskTitle(_taskId, value);

                                print("$value updated");
                              }
                            }
                            // _descriptionFocus.requestFocus();
                          },
                          controller: enterTaskTitleController,

                          decoration: InputDecoration(
                            hintText: "List Name...",
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
                          onChanged: (value) async {
                            if (value != "") {
                              if (_taskId != 0) {
                                await _dbHelper.updateTaskDescription(
                                    _taskId, value);
                                _taskDescription = value;
                              }
                            }

                            // _todoFocus.requestFocus();
                          },
                          controller: enterTaskDescriptionController,
                          decoration: InputDecoration(
                              hintText: "Description... ",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 24,
                              ))),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    // wrap inside a consumer
                    child: Consumer<DatabaseHelper>(
                      builder: (context, todos, child) =>
                       FutureBuilder(
                          initialData: [],
                          future: todos.getTodos(_taskId),
                          builder: (context, snapshot) {
                              return Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                        return TodoWidget(
                                          id:snapshot.data[index].id,
                                            text: snapshot.data[index].title,
                                            isDone: snapshot.data[index].isDone == 0 ? false : true,
                                          );
                                    }),
                              );
                          }),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.add_circle_rounded,color: Colors.blue,),
                              onPressed: () async {
                                // Check if field is not empty
                                if (enterTodoItemController.text != "") {
                                  // Check if task if null
                                  if (_taskId != 0) {
                                    Todo _newTodo = Todo(
                                      title: enterTodoItemController.text,
                                      isDone: 0,
                                      taskId: _taskId,
                                    );
                                    Provider.of<DatabaseHelper>(context, listen: false).insertTodo(_newTodo);
                                    enterTodoItemController..text = "";
                                    print("Todo has been added");
                                    // setState(() {});
                                    _todoFocus.requestFocus();
                                  }
                                }
                              }),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   margin: EdgeInsets.only(
                          //     right: 12,
                          //   ),
                          //   child: Icon(Icons.check_box_outline_blank_rounded,
                          //       color: Colors.black26),
                          //   decoration: BoxDecoration(
                          //     // color: Color(0xFF7349FE),
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          // ),
                          Expanded(
                            //make the field as typeaheadfield
                            child: TextField(
                              controller: enterTodoItemController,
                              focusNode: _todoFocus,
                              // onChanged: (value) {
                              //   setState(() {
                              //     _userInput = value;
                              //   });
                              // },
                              onSubmitted: (value) async {
                                // Check if field is not empty
                                  if (value != "") {
                                  // Check if task if null
                                    if(_taskId != 0) {
                                    Todo _newTodo = Todo(
                                      title: value,
                                      isDone: 0,
                                      taskId: _taskId,
                                    );

                                    await _dbHelper.insertTodo(_newTodo);

                                    print("Todo has been added");
                                    _userInput = "";
                                    setState(() {});

                                    _todoFocus.requestFocus();
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Type Item here...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: false,
                child: Positioned(
                  bottom: 12,
                  right: 24,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != 0) {
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
                            colors: [Colors.pink[300], Colors.pink],
                            begin: Alignment(0, -1),
                          ),
                        ),
                        child: Container(
                            child: Icon(Icons.delete_sweep_rounded,
                                size: 32, color: Colors.white))),
                  ),
                ),
              ),

              // Positioned(
              //   right: 12,
              //   top: 40,
              //   width: 240,
              //   child: TypeAheadField(
              //       suggestionsCallback: (pattern) async {
              //         return await StateService.getSuggestions(pattern);
              //       },
              //       itemBuilder: (context, suggestion) {
              //         return ListTile(
              //           leading: Icon(Icons.add_photo_alternate_outlined,color: Colors.pink),
              //           // title:Text(suggestion),
              //           title: Text(suggestion['name']),
              //           subtitle: Text(suggestion['brand'] ?? ""),
              //         );
              //       },
              //       onSuggestionSelected: (suggestion) {
              //         return suggestion['name'];
              //       }),
              // ),

            ],
          ),
        ),
      ),
    );
  }

}

class StateService {

  static getSuggestions(String pattern) {
    List<Map<String, dynamic>> separatedMatches = List();

    if(allProducts != null) {
      print(pattern);
      List matches = List();
      matches.addAll(allProducts);
      matches.retainWhere((item) =>
          item['name'].toLowerCase().contains(pattern.toLowerCase()));
      // print(matches);
      for(var match in matches) {
        if (match['name'].contains('|')) {
          List names = match['name'].split('|');
          for(var name in names){
            separatedMatches.add({'name': name,'brand':match['brand']});
          }
        }
        else{
          separatedMatches.add(match);
        }
      }
      return separatedMatches;
    }
  }
}
