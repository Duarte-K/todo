// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/repository/todo_repository.dart';

import 'widgets/todo_item.dart';

class HomePage extends StatefulWidget {
  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController control = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> tarefas = [];
  Todo? deletedTodo;
  int? position;
  String? errorMsg;

  @override
  void initState(){
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        tarefas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: control,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Adicione uma tarefa",
                          hintText: "Ex: Estudar Flutter",
                          errorText: errorMsg,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffffb74d),
                              width: 2,
                            )
                          ),
                          labelStyle: TextStyle(
                            color: Color(0xffffb74d),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: (){
                        String text = control.text;
                        if(text.isEmpty){
                          setState(() {
                            errorMsg = "O campo deve ser preenchido";
                          });
                          return;
                        }
                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            date: DateTime.now(),
                          );
                          tarefas.add(newTodo);
                          errorMsg = null;
                        });
                        control.clear();
                        todoRepository.saveList(tarefas);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange[300],
                        padding: EdgeInsets.all(14)
                      ),
                      child:Icon(
                        Icons.add,
                        size: 30,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for(Todo todo in tarefas)
                        TodoItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Você possui ${tarefas.length} tarefas pendentes"
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: showDialogTodo,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange[300],
                        padding: EdgeInsets.all(14)
                      ),
                      child: Text("Limpar tudo"),
                    )
                  ],
                ),
              ],
            ),
          ),
              ),
        ),
      ),
    );
  }

  void onDelete(Todo todo){
    deletedTodo = todo;
    position = tarefas.indexOf(todo);
    setState(() {
      tarefas.remove(todo);
    });
    todoRepository.saveList(tarefas);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:Text(
          "Tarefa ${todo.title} foi removida com sucesso!",
          style: TextStyle(
            color: Color(0xff060708),
          ),
        ),
        backgroundColor: Colors.grey[100],
        action: SnackBarAction(
          label: "Desfazer",
          textColor: Colors.orange[300],
          onPressed: (){
            setState(() {
              tarefas.insert(position!, deletedTodo!);
            });
            todoRepository.saveList(tarefas);
          }
        )
      ),
    );
  }

  void showDialogTodo(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Limpar"),
        content: Text("Tem certeza que deseja apagar todas as tarefas?"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            style: TextButton.styleFrom(primary: Colors.orange[300]),
            child: Text("Cancelar"),
            
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              deleteAll();
            }, 
            style: TextButton.styleFrom(primary: Colors.red),
            child: Text("Excluir"),
          )
        ],
      ),
    );
  }
  void deleteAll(){
    setState(() {
      tarefas.clear();
    });
    todoRepository.saveList(tarefas);
  }
}