import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../services/chat_service.dart';
import '../../services/navigation_service.dart';
import '../../services/service_locator.dart';
import '../../widgets/appbar_title.dart';
import 'add_channel_page.dart';
import 'widgets/selectable_user.dart';

class AddUsersPage extends StatelessWidget {
  static const route = '/addUsers';

  final List<User> _selectedUsers = [];

  void _addChannelMember(User user) {
    if (_selectedUsers.contains(user)) {
      _selectedUsers.remove(user);
    } else {
      _selectedUsers.add(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () {
          locator<NavigationService>()
              .navigateTo(AddChannelPage.route, arguments: _selectedUsers);
        },
      ),
      appBar: AppBar(
        title: AppBarTitleSubtitle(
          title: 'New Channel',
          subtitle: 'Add members',
        ),
      ),
      body: FutureBuilder(
        future: locator<ChatService>().getAllUsers(),
        builder: (contex, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Get current user and all other users
            // Display all users, except current user
            final currentUser = locator<ChatService>().currentUser;
            // add current user as a member of the channel
            _addChannelMember(currentUser);
            final users =
                snapshot.data.where((val) => val.id != currentUser.id);

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  for (var user in users)
                    SelectableUserWidget(
                        user: user, selected: _addChannelMember)
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
