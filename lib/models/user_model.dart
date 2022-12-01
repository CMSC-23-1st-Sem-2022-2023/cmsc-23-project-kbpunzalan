import 'dart:convert';

class UserModel {
  String? id;
  String username;
  String name;
  String birthdate;
  String location;
  List<dynamic>? friends;
  List<dynamic>? receivedFriendRequests;
  List<dynamic>? sentFriendRequests;

  // user constructor
  UserModel({
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
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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

  static List<UserModel> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<UserModel>((dynamic d) => UserModel.fromJson(d)).toList();
  }

  // converts into a User
  Map<String, dynamic> toJson(UserModel user) {
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
