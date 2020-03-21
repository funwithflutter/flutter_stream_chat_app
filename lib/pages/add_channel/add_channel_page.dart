import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../widgets/appbar_title.dart';
import 'widgets/create_channel_input.dart';
import 'widgets/user_icon.dart';

class AddChannelPage extends StatelessWidget {
  static const String route = '/addChannel';

  const AddChannelPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<User> users = ModalRoute.of(context).settings.arguments;
    final ids = users.map((user) => user.id).toList();
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleSubtitle(
          title: 'New Channel',
          subtitle: 'Details',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CreateChannelInputWidget(
                memberIDs: ids,
              ),
              SizedBox(
                height: 16,
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 16,
              ),
              Text('Selected members',
                  style: Theme.of(context).textTheme.subtitle),
              Wrap(
                children: <Widget>[
                  for (var user in users)
                    UserIcon(
                      user: user,
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
