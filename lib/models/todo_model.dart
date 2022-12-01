import 'dart:convert';

class Todo {
  String title;
  String description;
  bool status;
  String deadline;
  String? id;
  // final int userId;

  Todo({
    // required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.deadline,
    this.id,
  });

  // Factory constructor to instantiate object from json format
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      description: json['description'],
      status: json['status'],
      deadline: json['deadline'],
      id: json['id'],
      // userId: json['userId'],
    );
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Todo todo) {
    return {
      'title': todo.title,
      'description': todo.description,
      'status': todo.status,
      'deadline': todo.deadline,
      // 'userId': todo.userId,
    };
  }
}
