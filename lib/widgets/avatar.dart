import 'package:flutter/material.dart';

///头像处理类
class Avatar extends StatefulWidget {

  final String avatarUrl;

  Avatar(this.avatarUrl);

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            image: DecorationImage(
              image: AssetImage(widget.avatarUrl),
              fit: BoxFit.cover
            )
        ),
    );
  }
}
