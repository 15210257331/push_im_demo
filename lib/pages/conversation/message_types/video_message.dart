import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    try {
      if (widget.v2TimMessage.videoElem.videoUrl == null) {
        _controller = VideoPlayerController.file(
          File(widget.v2TimMessage.videoElem.videoPath),
        )..initialize().then((_) {
            setState(() {});
          }).catchError((err) {
            print("初始化视频发生错误$err");
          });
      } else {
        _controller = VideoPlayerController.network(
          widget.v2TimMessage.videoElem.videoUrl,
        )..initialize().then((_) {
            setState(() {});
          }).catchError((err) {
            print("初始化视频发生错误$err");
          });
      }
    } catch (err) {
      print("视频初始化发生异常");
    }

    if (!_controller.hasListeners) {
      _controller.addListener(() {
        print("播放着 ${_controller.value.isPlaying} ${_controller.value.position} ${_controller.value.duration} ${_controller.value.duration == _controller.value.position}");
        if (_controller.value.position == _controller.value.duration) {
          print("到头了 ${_controller.value.isPlaying}");
          if (!_controller.value.isPlaying) {
            setState(() {});
          }
        }
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    print("video message deactivate call ${widget.v2TimMessage.msgID}");
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return _controller.value.initialized
        ? Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(4)
      ),
            child: Stack(
              children: [
                Positioned(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
                Positioned(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        try {
                          setState(() {});
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            if (_controller.value.position == _controller.value.duration) {
                              _controller.seekTo(Duration(seconds: 0, microseconds: 0, milliseconds: 0));
                            }
                            _controller.play();
                            setState(() {});
                          }
                        } catch (err) {
                          EasyLoading.showError('错误');
                        }
                      },
                      child: Icon(_controller.value.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                    ),
                  ),
                  top: 0,
                  left: 0,
                  bottom: 0,
                  right: 0,
                ),
              ],
            ),
          )
        : CupertinoActivityIndicator(
        radius: 30.0
    );
  }
}
