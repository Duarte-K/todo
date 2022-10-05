// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore

import "package:flutter/material.dart";
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo/model/todo.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({ Key? key, required this.todo, required this.onDelete }) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey[200],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(DateFormat('dd/MM/yy - HH:mm').format(todo.date),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(todo.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              label: "Deletar",
              backgroundColor: Colors.red,
              icon: Icons.delete,
              onPressed: (context) {
                onDelete(todo);
              },
            ),
          ]
        ),
      ),
    );
  }
}