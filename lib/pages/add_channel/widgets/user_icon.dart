import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UserIcon extends StatelessWidget {
  UserIcon({Key key, this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.extraData['image'];
    final showImage = imageUrl != null;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: showImage ? NetworkImage(imageUrl) : null,
        child: showImage ? null : Text(user.name[0]),
      ),
    );
  }
}