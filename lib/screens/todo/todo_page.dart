import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/todo/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Todo"),
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
              padding: const EdgeInsets.all(20.0),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                Todo todo = Todo.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.grey[200],
                  shadowColor: Colors.grey[900],
                  margin: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListTile(
                      title: Text(todo.title),
                      subtitle: Text(todo.description),
                      leading: Checkbox(
                        value: todo.status,
                        onChanged: (bool? value) {
                          context
                              .read<TodoListProvider>()
                              .toggleStatus(index, value!);
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) => TodoModal(
                              //     type: 'Edit',
                              //     todoIndex: index,
                              //   ),
                              // );
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
                                builder: (BuildContext context) => TodoModal(
                                  type: 'Delete',
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete_outlined),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
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
}
