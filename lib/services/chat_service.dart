import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatService {
  Client client = Client(
    '23b4jrt8qj6f',
    logLevel: Level.INFO,
  );

  User get currentUser => client.state.user;

  Future<List<User>> getAllUsers() async {
    final val =
        await client.queryUsers({}, [SortOption('last_message_at')], {});
    return val.users;
  }
}
