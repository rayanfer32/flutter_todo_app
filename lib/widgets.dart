import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database_helper.dart';


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

  TaskCardWidget({this.id ,this.title, this.desc});

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
              right:0,
              child: IconButton(icon: Icon(Icons.delete_forever,color: Colors.pink[500],size: 32,),
                onPressed: (){
                Provider.of<DatabaseHelper>(context, listen: false).deleteTask(id);
                }
            ),
            ),
          ],
        ));
  }
}

class TodoWidget extends StatelessWidget{
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
              onTap: () async{
                if(isDone) {
                  Provider.of<DatabaseHelper>(context, listen: false)
                      .updateTodoDone(id, 0);
                }
                else{
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
                onChanged: (value){
                  // print(value);
                  print(textController.text);
                  Provider.of<DatabaseHelper>(context,listen: false).updateTodoText(this.id, textController.text);
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
                  )
              ),
            ),
            Container(
              child: IconButton(icon: Icon(Icons.delete_forever),onPressed:(){
                print("delete todo");
                Provider.of<DatabaseHelper>(context,listen: false).deleteTodo(this.id);
              }),
            ),
          ],
        ));
  }

}



// class SuggestionsBar extends StatelessWidget {
//   String userInput;
//   SuggestionsBar(String userInput);
//   @override
//   Widget build(BuildContext context) {
//     return Container(child: Text(userInput ?? "Type Something ..."));
//   }
// }
//



