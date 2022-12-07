import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/api/firebase_todo_api.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/models/user_model.dart';

class TodoListProvider with ChangeNotifier {
  late FirebaseTodoAPI firebaseService;
  late Stream<QuerySnapshot> _todosStream;
  Todo? _selectedTodo;
  String? _selectedUser;

  final FirebaseAuth auth = FirebaseAuth.instance;

  TodoListProvider() {
    firebaseService = FirebaseTodoAPI();
    fetchTodos();
  }

  // getter
  Stream<QuerySnapshot> get todos => _todosStream;
  Todo get selected => _selectedTodo!;
  String get selectedUser => _selectedUser!;

  changeSelectedTodo(Todo item) {
    _selectedTodo = item;
  }

  changeSelectedUser(String item) {
    _selectedUser = item;

    print("CHANGE SELECTED USER : $selectedUser");
  }

  void fetchTodos() {
    _todosStream = firebaseService.getAllTodos();
    notifyListeners();
  }

  void addTodo(Todo item) async {
    String message = await firebaseService.addTodo(item.toJson(item));
    print(message);
    notifyListeners();
  }

  void editTodo(
      String newTitle, String newDescription, String newDeadline) async {
    String message = await firebaseService.editTodo(
        _selectedTodo!.id, newTitle, newDescription, newDeadline);

    print(message);
    notifyListeners();
  }

  void editFriendTodo(
      String newTitle, String newDescription, String newDeadline) async {
    String message = await firebaseService.editFriendTodo(
        selectedUser, _selectedTodo!.id, newTitle, newDescription, newDeadline);

    print(message);
    notifyListeners();
  }

  void deleteTodo() async {
    String message = await firebaseService.deleteTodo(_selectedTodo!.id);
    print(message);
    notifyListeners();
  }

  // toggles status to true or false so that the checkbox will be checked or unchecked
  void toggleStatus(bool status) async {
    String message =
        await firebaseService.editStatus(_selectedTodo!.id, status);
    print(message);
    notifyListeners();
  }
}
