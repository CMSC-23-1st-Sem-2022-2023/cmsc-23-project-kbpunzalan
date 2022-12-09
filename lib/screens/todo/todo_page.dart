import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/screens/todo/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/auth_provider.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    User? user = context.read<AuthProvider>().user;

    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;

    print("STREAM: $todosStream");

    print("III: ${user?.uid}");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: const Text("Todo"),
        ),
        body: StreamBuilder(
          stream: todosStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error encountered! ${snapshot.error}"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text("No Todos Found"),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                Todo todo = Todo.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);
                return GestureDetector(
                  onTap: () => viewTodo(todo),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.grey[200],
                    shadowColor: Colors.grey[900],
                    margin: const EdgeInsets.all(10.0),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(todo.title),
                                  subtitle: Text(todo.description),
                                  leading: Checkbox(
                                    activeColor: Colors.grey[900],
                                    checkColor: Colors.white,
                                    value: todo.status,
                                    onChanged: (bool? value) {
                                      // print("STATUS: $value");
                                      context
                                          .read<TodoListProvider>()
                                          .changeSelectedTodo(todo);
                                      context
                                          .read<TodoListProvider>()
                                          .toggleStatus(value!);
                                      TodoModal(
                                        type: 'Edit',
                                      );
                                    },
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          context
                                              .read<TodoListProvider>()
                                              .changeSelectedTodo(todo);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                TodoModal(
                                              type: 'Edit',
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.create_outlined),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          context
                                              .read<TodoListProvider>()
                                              .changeSelectedTodo(todo);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                TodoModal(
                                              type: 'Delete',
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.delete_outlined),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[900],
          // foregroundColor: Colors.grey,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => TodoModal(
                type: 'Add',
              ),
            );
          },
          child: const Icon(Icons.add_outlined),
        ),
      ),
    );
  }

  viewTodo(Todo todo) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          // Get available height and width of the build area of this widget. Make a choice depending on the size.

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Text(
            todo.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          content: SizedBox(
            height: height - 400,
            width: width - 200,
            child: SingleChildScrollView(
              child: ListBody(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.picture_in_picture_outlined),
                      SizedBox(width: 10),
                      Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(todo.description),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Icon(Icons.calendar_month),
                      SizedBox(width: 10),
                      Text(
                        "Deadline",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(todo.deadline),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Icon(Icons.edit_calendar_rounded),
                      SizedBox(width: 10),
                      Text(
                        "Last Modified",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text("${todo.lastEditedBy}"),
                  Text("${todo.lastEditedDate}"),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
