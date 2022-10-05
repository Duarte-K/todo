// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/model/todo.dart';

class TodoRepository{

  // TodoRepository(){
  //   SharedPreferences.getInstance().then((value) => preferences = value);
  // }
  
  late SharedPreferences preferences;

  Future<List<Todo>> getTodoList() async{
    preferences = await SharedPreferences.getInstance();
    final String jsonString = preferences.getString("todoList") ?? "[]";
    final List decoder = json.decode(jsonString) as List;
    return decoder.map((e) => Todo.fromJson(e)).toList();
  }

  void saveList(List<Todo> todos){
    final jsonString = json.encode(todos);
    preferences.setString("todoList", jsonString);
  }
}