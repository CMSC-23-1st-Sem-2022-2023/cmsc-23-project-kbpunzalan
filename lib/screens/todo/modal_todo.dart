import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:intl/intl.dart';

class TodoModal extends StatelessWidget {
  String type;
  // int todoIndex;
  final todoFormKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  TodoModal({
    super.key,
    required this.type,
  });

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add':
        return const Text(
          "Add new todo",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        );
      case 'Edit':
        return const Text(
          "Edit todo",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        );
      case 'Edit Friend':
        return const Text(
          "Edit Friend's Todo",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        );
      case 'Delete':
        return const Text(
          "Delete todo",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        );
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    // Use context.read to get the last updated list of todos
    // List<Todo> todoItems = context.read<TodoListProvider>().todo;

    switch (type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${context.read<TodoListProvider>().selected.title}'?",
          );
        }
      // Edit and add will have input field in them
      default:
        if (type == 'Edit' || type == 'Edit Friend') {
          _titleController.text =
              context.read<TodoListProvider>().selected.title;
          _descriptionController.text =
              context.read<TodoListProvider>().selected.description;
          _deadlineController.text =
              context.read<TodoListProvider>().selected.deadline;
        }
        return Form(
          key: todoFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // initialValue: context.read<TodoListProvider>().selected.title ||,
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Enter Title",
                    icon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title field cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Enter Description",
                    icon: Icon(Icons.picture_in_picture_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Description field cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller:
                      _deadlineController, //editing controller of this TextField
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Enter Deadline" //label text of field
                      ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      print(
                          pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(
                          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                      print(
                          formattedDate); //formatted date output using intl package =>  2022-07-04
                      //You can format date as per your need

                      _deadlineController.text = formattedDate;
                    } else {
                      print("Date is not selected");
                    }
                  },
                  validator: (value) {
                    if (value == "") {
                      return "Deadline field cannot be empty!";
                    } else {
                      _deadlineController.text = value.toString();
                      return null;
                    }
                  },
                ),
              ),
            ],
          ),
        );
    }
  }

  TextButton _dialogAction(BuildContext context) {
    // List<Todo> todoItems = context.read<TodoListProvider>().todo;

    return TextButton(
      onPressed: () {
        switch (type) {
          case 'Add':
            {
              if (todoFormKey.currentState!.validate()) {
                // Navigator.of(context).pop();
                Todo temp = Todo(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  status: false,
                  deadline: _deadlineController.text,
                );

                context.read<TodoListProvider>().addTodo(temp);

                // Remove dialog after adding
                Navigator.of(context).pop();
              }
              break;
            }
          case 'Edit':
            {
              if (todoFormKey.currentState!.validate()) {
                context.read<TodoListProvider>().editTodo(_titleController.text,
                    _descriptionController.text, _deadlineController.text);

                // Remove dialog after editing
                Navigator.of(context).pop();
              }
              break;
            }
          case 'Edit Friend':
            {
              if (todoFormKey.currentState!.validate()) {
                context.read<TodoListProvider>().editFriendTodo(
                    _titleController.text,
                    _descriptionController.text,
                    _deadlineController.text);

                // Remove dialog after editing
                Navigator.of(context).pop();
              }
            }
            break;
          case 'Delete':
            {
              context.read<TodoListProvider>().deleteTodo();

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(
        type,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: _buildTitle(),
        content: _buildContent(context),

        // Contains two buttons - add/edit/delete, and cancel
        actions: <Widget>[
          _dialogAction(context),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              "Cancel",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
