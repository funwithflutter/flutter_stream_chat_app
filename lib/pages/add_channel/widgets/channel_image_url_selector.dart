import 'package:flutter/material.dart';

import '../../../services/network_service.dart';
import '../../../widgets/loading_button_child.dart';

class ChannelImageUrlSelector extends StatefulWidget {
  const ChannelImageUrlSelector({Key key, @required this.editingController})
      : super(key: key);

  final TextEditingController editingController;

  @override
  _ChannelImageUrlSelectorState createState() =>
      _ChannelImageUrlSelectorState();
}

class _ChannelImageUrlSelectorState extends State<ChannelImageUrlSelector> {
  String imageUrl;
  bool _isLoading = false;
  PersistentBottomSheetController _bottomSheetController;

  void setUrl(String url) async {
    setState(() {
      imageUrl = url;
    });
    Navigator.pop(context);
  }

  void _setLoadingState(bool isLoading) {
    _bottomSheetController.setState(() {
      _isLoading = isLoading;
    });
  }

  final _formKey = GlobalKey<FormState>();
  bool _isBottomSheetOpen = false;

  @override
  Widget build(BuildContext context) {
    final showImage = imageUrl != null;
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if (_isBottomSheetOpen) {
                _bottomSheetController.close();
              } else {
                _bottomSheetController = showBottomSheet(
                  context: context,
                  builder: (context) => _bottomSheetWidget(),
                  backgroundColor: Colors.transparent,
                );
              }
              _isBottomSheetOpen = !_isBottomSheetOpen;
            },
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey,
              backgroundImage: showImage ? NetworkImage(imageUrl) : null,
              child: showImage
                  ? null
                  : Icon(
                      Icons.portrait,
                      size: 50,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomSheetWidget() {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: widget.editingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Image URL',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a URL';
                    }
                    final isValidURL = Uri.parse(value).isAbsolute;
                    if (!isValidURL) {
                      return 'Not a valid URL';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  onPressed: () async {
                    _bottomSheetController.close();
                    _isBottomSheetOpen = false;
                  },
                  child: Text('Close'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      final url = widget.editingController.value.text;
                      _setLoadingState(true);
                      if (await isValidImageUrl(url)) {
                        setUrl(url);
                      }
                      _setLoadingState(false);
                    }
                  },
                  child: LoadingButtonChild(
                    title: 'Set Picture',
                    isLoading: _isLoading,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
