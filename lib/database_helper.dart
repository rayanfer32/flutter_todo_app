import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:core';
import 'models/task.dart';
import 'models/todo.dart';

import 'package:provider/provider.dart';

class DatabaseHelper extends ChangeNotifier{

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY ,title TEXT ,description TEXT)",
        );
        await db.execute(
          "CREATE TABLE todo(id INTEGER PRIMARY KEY ,taskId INTEGER,title TEXT ,isDone INTEGER)",
        );
        return db;
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskId =0;

    Database _db = await database();
    await _db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
        taskId = value;
    });
    notifyListeners();
    return taskId;
  }



  Future<void> updateTaskTitle(int id,String title) async {
    Database _db = await database();

    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
    // notifyListeners();
  }

  Future<void> updateTaskDescription(int id,String description) async {
    Database _db = await database();

    await _db.rawUpdate("UPDATE tasks SET description = '$description' WHERE id = '$id'");
    // notifyListeners();

  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  Future<void> deleteTodo(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM todo WHERE id = '$id'");
    notifyListeners();
  }

  Future<void> updateTodoDone(int id,int isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
    notifyListeners();
  }

  Future<void> updateTodoText(int id,String text) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET title = '$text' WHERE id = '$id'");
    // notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    Database _db = await database();

    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");
    notifyListeners();
  }

  Future<List<Task>> getTasks() async{

    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');

    print("get tasks");
    return List.generate(taskMap.length, (index) {

      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description']);
    });

  }

  Future<List<Todo>> getTodos(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery('SELECT * FROM todo WHERE taskId = $taskId');
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          taskId: todoMap[index]['taskId'],
          title: todoMap[index]['title'],
          isDone: todoMap[index]['isDone']);
    });
  }
}
