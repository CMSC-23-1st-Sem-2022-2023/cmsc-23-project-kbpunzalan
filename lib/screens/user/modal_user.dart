import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';

class UserModal extends StatelessWidget {
  String type;
  final TextEditingController _formFieldController = TextEditingController();

  UserModal({super.key, required this.type});

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add Friend':
        return const Text("Add User");
      case 'Cancel Request':
        return const Text("Cancel Request");
      case 'Unfriend':
        return const Text("Unfriend User");
      case 'Confirm':
        return const Text("Confirm User");
      case 'Reject':
        return const Text("Reject User");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  // Use context.read to get the last updated list of users
  Widget _buildContent(BuildContext context) {
    switch (type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to reject '${context.read<UserProvider>().selected.username}'?",
          );
        }
      case 'Add Friend':
        {
          return Text(
            "Add user '${context.read<UserProvider>().selected.username}'?",
          );
        }
      case 'Cancel Request':
        {
          return Text(
            "Cancel request for '${context.read<UserProvider>().selected.username}'?",
          );
        }
      case 'Confirm':
        {
          return Text(
            "Add '${context.read<UserProvider>().selected.username}' to your friends list?",
          );
        }
      case 'Reject':
        {
          return Text(
            "Remove '${context.read<UserProvider>().selected.username}' from your friend request?",
          );
        }
      case 'Unfriend':
        {
          return Text(
            "Remove '${context.read<UserProvider>().selected.username}' from your friends list?",
          );
        }
      // Edit and add will have input field in them
      default:
        return Text("");
    }
  }

  TextButton _dialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (type) {
          case 'Add Friend':
            {
              context.read<UserProvider>().addUser();

              Navigator.of(context).pop();
              break;
            }
          case 'Cancel Request':
            {
              context.read<UserProvider>().cancelRequest();

              Navigator.of(context).pop();
              break;
            }
          case 'Confirm':
            {
              context.read<UserProvider>().acceptUser();

              Navigator.of(context).pop();
              break;
            }
          case 'Reject':
            {
              context.read<UserProvider>().rejectUser();

              Navigator.of(context).pop();
              break;
            }
          case 'Unfriend':
            {
              context.read<UserProvider>().unfriendUser();

              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
