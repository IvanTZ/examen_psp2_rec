import 'package:flutter/services.dart';

import '../models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UserCard extends StatelessWidget {
  final User user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Image.network(user.photo)),
      title: Text(user.name),
      subtitle: Text(
        "${user.email}",
        style: TextStyle(color: Colors.black.withOpacity(0.6)),
      ),
    );
  }
}
