import 'dart:convert';

class UserModel {
  String? id;
  String username;
  String firstName;
  String lastName;
  String email;
  String birthdateInput;
  String location;
  List<dynamic>? friends;
  List<dynamic>? receivedFriendRequests;
  List<dynamic>? sentFriendRequests;

  // user constructor
  UserModel({
    this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthdateInput,
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
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      birthdateInput: json['birthdateInput'],
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
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'friends': user.friends,
      'birthdateInput': user.birthdateInput,
      'location': user.location,
      'receivedFriendRequests': user.receivedFriendRequests,
      'sentFriendRequests': user.sentFriendRequests,
    };
  }
}
