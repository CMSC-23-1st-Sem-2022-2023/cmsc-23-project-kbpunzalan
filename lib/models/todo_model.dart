import 'dart:convert';

class Todo {
  String title;
  String description;
  bool status;
  String? id;
  // final int userId;

  Todo({
    // required this.userId,
    required this.title,
    required this.description,
    required this.status,
    this.id,
  });

  // Factory constructor to instantiate object from json format
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      description: json['description'],
      status: json['status'],
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
      // 'userId': todo.userId,
    };
  }
}
