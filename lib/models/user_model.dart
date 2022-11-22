import 'dart:convert';

class User {
  String? id;
  String username;
  String name;
  String birthdate;
  String location;
  List<dynamic>? friends;
  List<dynamic>? receivedFriendRequests;
  List<dynamic>? sentFriendRequests;

  // user constructor
  User({
    this.id,
    required this.username,
    required this.name,
    required this.birthdate,
    required this.location,
    this.friends,
    this.receivedFriendRequests,
    this.sentFriendRequests,
  });

  // parse json to User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      birthdate: json['birthdate'],
      location: json['location'],
      friends: json['friends'],
      receivedFriendRequests: json['receivedFriendRequests'],
      sentFriendRequests: json['sentFriendRequests'],
    );
  }

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  // converts into a User
  Map<String, dynamic> toJson(User user) {
    return {
      'username': user.username,
      'name': user.name,
      'friends': user.friends,
      'birthdate': user.birthdate,
      'location': user.location,
      'receivedFriendRequests': user.receivedFriendRequests,
      'sentFriendRequests': user.sentFriendRequests,
    };
  }
}
