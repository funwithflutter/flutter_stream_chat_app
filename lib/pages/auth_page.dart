import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../services/chat_service.dart';
import '../services/navigation_service.dart';
import '../services/service_locator.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  static const route = '/auth';
  const AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;

  void _setLoadingState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _setUser(String id) async {
    final client = locator<ChatService>().client;
    _setLoadingState();
    try {
      await client.disconnect();
    } catch(e) {
      print(e);
      print('not yet authenticated');
    }
    await client.setUser(
      User(
        id: id,
        // extraData: {
        //   "image": "https://i.imgur.com/fR9Jz14.png",
        // },
      ),
      client.devToken(id),
    );
    _setLoadingState();
    await locator<NavigationService>().navigateTo(HomePage.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _title(context),
            _notice(context),
            _userButton('Bernard'),
            _userButton('John'),
            _userButton('James'),
            _userButton('Jessica'),
            _userButton('Leonard'),
            _loadingIndicator(),
          ],
        ),
      ),
    );
  }

  Container _loadingIndicator() {
    return Container(
      height: 50,
      width: 50,
      child: _isLoading ? CircularProgressIndicator() : Container(),
    );
  }

  Padding _notice(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('This is not a real auth page',
          style: Theme.of(context).textTheme.caption),
    );
  }

  Padding _title(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('Choose a User', style: Theme.of(context).textTheme.display1),
    );
  }

  Widget _userButton(String name) {
    return RaisedButton(
      child: Text(name),
      onPressed: _isLoading
          ? null
          : () {
              _setUser(name);
            },
    );
  }
}
