import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// 图片预览
class PhotoView extends StatefulWidget {
  final List<String> galleryList;

  const PhotoView({Key key, this.galleryList}) : super(key: key);

  @override
  _PhotoViewGalleryState createState() => _PhotoViewGalleryState();
}

class _PhotoViewGalleryState extends State<PhotoView> {
  PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          onTapUp: (a, b, c) => Navigator.of(context).pop(),
          imageProvider: NetworkImage(widget.galleryList[index]),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          heroAttributes: PhotoViewHeroAttributes(tag: widget.galleryList[index]),
        );
      },
      itemCount: widget.galleryList.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
          ),
        ),
      ),
      // backgroundDecoration: widget.backgroundDecoration,
      pageController: pageController,
      onPageChanged: (index) {
        setState(() {
          print(index);
          // nowPosition = index;
          // _initData();
        });
      },
    ));
  }
}
