import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../services/chat_service.dart';
import '../../../services/service_locator.dart';
import '../../../widgets/loading_button_child.dart';
import '../../auth_page.dart';
import '../../home_page.dart';
import 'channel_image_url_selector.dart';

class CreateChannelInputWidget extends StatefulWidget {
  const CreateChannelInputWidget({
    Key key,
    this.memberIDs = const [],
  }) : super(key: key);

  final List<String> memberIDs;

  @override
  _CreateChannelInputWidgetState createState() =>
      _CreateChannelInputWidgetState();
}

class _CreateChannelInputWidgetState extends State<CreateChannelInputWidget> {
  TextEditingController _textChannelName;
  TextEditingController _textImageUrl;
  Channel channel;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textChannelName = TextEditingController();
    _textImageUrl = TextEditingController();
  }

  @override
  void dispose() {
    _textChannelName.dispose();
    super.dispose();
  }

  void _setStateLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<bool> _createChannel() async {
    final channelName = _textChannelName.value.text;
    final imageURL = _textImageUrl.value.text;
    final client = locator<ChatService>().client;
    if (imageURL == null || imageURL.isEmpty) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please set a channel image'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      );
      return false;
    }
    channel = client.channel(
      'messaging',
      id: Uuid().v1(), // generate a random id
      extraData: {
        'name': channelName,
        'image': imageURL,
        'members': widget.memberIDs,
      },
    );
    // await channel.create();
    await channel.watch();
    return true;
  }

  void _returnToChat() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        HomePage.route, ModalRoute.withName(AuthPage.route));
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ChannelImageUrlSelector(
                editingController: _textImageUrl,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _textChannelName,
                      // onSubmitted: (value) {},
                      decoration: InputDecoration(
                        hintText: 'Channel name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a channel name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  _setStateLoading(true);
                  final channelCreated = await _createChannel();
                  _setStateLoading(false);
                  if (channelCreated) {
                    _returnToChat();
                  }
                },
                child: LoadingButtonChild(
                  title: 'Create',
                  isLoading: _isLoading,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
