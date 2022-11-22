import 'dart:convert';

class User {
  String? id;
  String userName;
  String displayName;
  List<dynamic>? friends;
  List<dynamic>? receivedFriendRequests;
  List<dynamic>? sentFriendRequest;

  // user constructor
  User({
    this.id,
    required this.userName,
    required this.displayName,
    this.friends,
    this.receivedFriendRequests,
    this.sentFriendRequest,
  });

  // parse json to User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      displayName: json['displayName'],
      friends: json['friends'],
      receivedFriendRequests: json['receivedFriendRequests'],
      sentFriendRequest: json['sentFriendRequest'],
    );
  }

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  // converts into a User
  Map<String, dynamic> toJson(User user) {
    return {
      'userName': user.userName,
      'displayName': user.displayName,
      'friends': user.friends,
      'receivedFriendRequests': user.receivedFriendRequests,
      'sentFriendRequest': user.sentFriendRequest,
    };
  }
}
