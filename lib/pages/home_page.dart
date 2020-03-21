import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../services/chat_service.dart';
import '../services/navigation_service.dart';
import '../services/service_locator.dart';
import '../styles/theme.dart';
import 'add_channel/add_users_page.dart';
import 'channel_page.dart';

class HomePage extends StatelessWidget {
  static const route = '/home';
  const HomePage({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamChat(
        client: locator<ChatService>().client,
        streamChatThemeData: StreamChatThemeData.fromTheme(lightTheme).copyWith(
          // channelPreviewTheme: ChannelPreviewTheme(),
          ownMessageTheme: MessageTheme(
            messageBackgroundColor: Colors.black,
            messageText: TextStyle(
              color: Colors.white,
            ),
            avatarTheme: AvatarTheme(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          channelTheme: ChannelTheme(
            channelHeaderTheme: ChannelHeaderTheme(
              color: Theme.of(context).primaryColor,
              title: Theme.of(context).textTheme.title.copyWith(
                    color: Colors.white,
                  ),
              lastMessageAt: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ),
        child: ChannelListPage(),
      ),
    );
  }
}

class ChannelListPage extends StatelessWidget {

  Widget _channelPreviewBuilder(BuildContext context, Channel channel) {
    final lastMessage = channel.state.messages.reversed.firstWhere(
      (message) => message.type != "deleted",
      orElse: () => null,
    );

    final subtitle = (lastMessage == null ? "nothing yet" : lastMessage.text);
    final opacity = channel.state.unreadCount > .0 ? 1.0 : 0.5;

    return ListTile(
      leading: ChannelImage(),
      title: ChannelName(
        textStyle:
            StreamChatTheme.of(context).channelPreviewTheme.title.copyWith(
                  color: Colors.black.withOpacity(opacity),
                ),
      ),
      subtitle: Text(subtitle),
      trailing: channel.state.unreadCount > 0
          ? CircleAvatar(
              radius: 10,
              child: Text(channel.state.unreadCount.toString()),
            )
          : SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          locator<NavigationService>().navigateTo(AddUsersPage.route);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Channels'),
      ),
      body: ChannelListView(
        filter: {
          'members': {
            '\$in': [StreamChat.of(context).user.id],
          }
        },
        channelPreviewBuilder: _channelPreviewBuilder,
        sort: [SortOption('last_message_at')],
        pagination: PaginationParams(
          limit: 20,
        ),
        channelWidget: ChannelPage(),
      ),
    );
  }
}
