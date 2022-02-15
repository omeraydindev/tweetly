import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    Key? key,
    required this.imageProvider,
    required this.tag,
  }) : super(key: key);

  final ImageProvider imageProvider;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 1.1,
        heroAttributes: PhotoViewHeroAttributes(tag: tag),
      ),
    );
  }
}
