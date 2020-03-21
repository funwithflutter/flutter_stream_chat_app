import 'package:flutter/material.dart';

class AppBarTitleSubtitle extends StatelessWidget {
  const AppBarTitleSubtitle({
    Key key,
    @required this.title,
    @required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title),
        Text(
          subtitle,
          style:
              Theme.of(context).textTheme.subhead.copyWith(color: Colors.white),
        )
      ],
    );
  }
}
