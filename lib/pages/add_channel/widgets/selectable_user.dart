import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SelectableUserWidget extends StatefulWidget {
  const SelectableUserWidget(
      {Key key, @required this.user, @required this.selected})
      : assert(user != null && selected != null),
        super(key: key);

  final User user;
  final Function(User) selected;

  @override
  _SelectableUserWidgetState createState() => _SelectableUserWidgetState();
}

class _SelectableUserWidgetState extends State<SelectableUserWidget> {
  bool selected = false;

  void _select() {
    setState(() {
      selected = !selected;
    });
    widget.selected(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.user.extraData['image'];
    final showImage = imageUrl != null;
    return GestureDetector(
      onTap: _select,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: showImage ? NetworkImage(imageUrl) : null,
          child: showImage ? null : Text(widget.user.name[0]),
        ),
        title: Text(widget.user.name),
        trailing: Checkbox(
          value: selected,
          onChanged: (val) {
            _select();
          },
        ),
      ),
    );
  }
}
