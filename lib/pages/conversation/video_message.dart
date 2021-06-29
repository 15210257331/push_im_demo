import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:push_im_demo/widgets/video_player.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:video_player/video_player.dart';

class VideoMessage extends StatefulWidget {

  final V2TimMessage v2TimMessage;

  const VideoMessage({Key key, this.v2TimMessage}) : super(key: key);

  @override
  _VideoMessageState createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {

  @override
  void initState() {
    super.initState();
    print(widget.v2TimMessage);
  }


  @override
  void dispose() {
    super.dispose();
  }

  void playVideo() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => VideoPage(widget.v2TimMessage.videoElem.videoUrl)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(widget.v2TimMessage.videoElem.snapshotUrl)
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              height: widget.v2TimMessage.videoElem.snapshotHeight.toDouble(),
              width: widget.v2TimMessage.videoElem.snapshotWidth.toDouble(),
              color: Colors.black12.withOpacity(0.3),
            ),
        ),
        GestureDetector(
          onTap: playVideo,
          child: Icon(
            Icons.play_circle_outline,
            size: 48,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
