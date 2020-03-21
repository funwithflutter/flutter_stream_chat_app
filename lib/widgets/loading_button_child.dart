import 'package:flutter/material.dart';

class LoadingButtonChild extends StatelessWidget {
  LoadingButtonChild({
    Key key,
    @required this.isLoading,
    @required this.title,
    this.color = Colors.black,
  }) : super(key: key);

  final bool isLoading;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          )
        : Text(
            title,
            style: TextStyle(color: color),
          );
  }
}
