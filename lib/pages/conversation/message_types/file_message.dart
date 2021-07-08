import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';

class FileMessage extends StatefulWidget {

  final V2TimMessage v2TimMessage;

  const FileMessage({Key key, this.v2TimMessage}) : super(key: key);

  @override
  _FileMessageState createState() => _FileMessageState();
}

class _FileMessageState extends State<FileMessage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(4)
          ),
          child: Container(
            color: Colors.white,
            child: Row(
              textDirection: widget.v2TimMessage.isSelf ? TextDirection.ltr : TextDirection.rtl,
              children: [
                Container(
                  child: Icon(Icons.file_copy, size: 45, color: Theme.of(context).primaryColor,),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.v2TimMessage.fileElem.fileName,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${widget.v2TimMessage.fileElem.fileSize} KB",
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )

      ),
    );
  }
}
