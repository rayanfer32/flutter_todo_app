import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database_helper.dart';
import 'suggestions_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class TaskCardWidget extends StatelessWidget {
  final int id;
  final String title;
  final String desc;

  TaskCardWidget({this.id, this.title, this.desc});

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
            Positioned(
              right: 0,
              child: IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.pink[500],
                    size: 32,
                  ),
                  onPressed: () {
                    Provider.of<DatabaseHelper>(context, listen: false)
                        .deleteTask(id);
                  }),
            ),
          ],
        ));
  }
}

class TodoWidget extends StatelessWidget {
  final int id;
  final String text;
  final bool isDone;
  final textController = TextEditingController();

  TodoWidget({this.id, this.text, @required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 0,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                if (isDone) {
                  Provider.of<DatabaseHelper>(context, listen: false)
                      .updateTodoDone(id, 0);
                } else {
                  Provider.of<DatabaseHelper>(context, listen: false)
                      .updateTodoDone(id, 1);
                }
              },
              child: Container(
                width: 24,
                height: 24,
                margin: EdgeInsets.only(
                  right: 8,
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
            ),
            Flexible(
              child: TextField(
                  onChanged: (value) {
                    // print(value);
                    print(textController.text);
                    Provider.of<DatabaseHelper>(context, listen: false)
                        .updateTodoText(this.id, textController.text);
                    // textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.text.length));
                  },
                  // focusNode: textFocusNode,
                  controller: textController..text = text ?? "{Blank Todo}",
                  style: TextStyle(
                    color: isDone ? Colors.deepPurple : Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: "Item...",
                    border: InputBorder.none,
                  )),
            ),
            Container(
              child: IconButton(
                  icon: Icon(Icons.close_rounded, color: Colors.pink),
                  onPressed: () {
                    print("delete todo");
                    Provider.of<DatabaseHelper>(context, listen: false)
                        .deleteTodo(this.id);
                  }),
            ),
          ],
        ));
  }
}

class SuggestionsWidget extends StatelessWidget {
  final TextEditingController input;
  final List suggestion;

  SuggestionsWidget({this.input,this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: ((input.text != "") && (suggestion.length != 0)) ? true : false,
      child: Container(
        width: double.infinity,
        height: 100,
        // padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: Colors.pink[100], borderRadius: BorderRadius.circular(12)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: suggestion.length,
          itemBuilder: (context, index) {
            var iconPath;
            if(suggestion[index]['iconPath'] != null){
              iconPath = suggestion[index]['iconPath'];
             }
            else{
              iconPath = 'assets/svg/bowl.svg';
            }

            return Container(
              width: 88,
              child: GestureDetector(
                onTap: (){
                  String name = suggestion[index]['name'].trim();
                  print(name);
                  input..text = name;
                  input.selection = TextSelection.fromPosition(TextPosition(offset: input.text.length));
                  // Provider.of<DatabaseHelper>(context, listen: false).insertTodo(_newTodo);
                },
                child: Card(
                  child: GridTile(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(iconPath),
                    ),
                    footer: Center(child: Text(suggestion[index]['name'].trim())),
                    // footer: Text(suggestion[index]['brand'] ?? ""),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
