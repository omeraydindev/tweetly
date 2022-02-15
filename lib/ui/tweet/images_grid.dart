import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/screens/view_photo.dart';
import 'package:tweetly/utils/random.dart';

class ImagesGrid extends StatefulWidget {
  const ImagesGrid({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<String> images;

  @override
  State<ImagesGrid> createState() => _ImagesGridState();
}

class _ImagesGridState extends State<ImagesGrid> {
  @override
  Widget build(BuildContext context) {
    // crossAxis -> horizontal
    // mainAxis  -> vertical
    const mainAxisMultiplier = 1.25;

    final imgCount = widget.images.length;
    final grid = StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: [
        if (imgCount > 0)
          StaggeredGridTile.count(
            crossAxisCellCount: imgCount == 1 ? 4 : 2,
            mainAxisCellCount: (imgCount != 4 ? 2 : 1) * mainAxisMultiplier,
            child: TileImage(imageId: widget.images[0]),
          ),
        if (imgCount > 1)
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: (imgCount == 2 ? 2 : 1) * mainAxisMultiplier,
            child: TileImage(imageId: widget.images[1]),
          ),
        if (imgCount > 2)
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1 * mainAxisMultiplier,
            child: TileImage(imageId: widget.images[2]),
          ),
        if (imgCount > 3)
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1 * mainAxisMultiplier,
            child: TileImage(imageId: widget.images[3]),
          ),
      ],
    );
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      child: grid,
    );
  }
}

class TileImage extends StatefulWidget {
  const TileImage({
    Key? key,
    required this.imageId,
  }) : super(key: key);

  final String imageId;

  @override
  State<TileImage> createState() => _TileImageState();
}

class _TileImageState extends State<TileImage> {
  @override
  Widget build(BuildContext context) {
    final heroTag = generateRandomString();

    return Hero(
      tag: heroTag,
      child: CachedNetworkImage(
        imageUrl: API.getImageURLForId(widget.imageId),
        imageBuilder: (context, imageProvider) {
          return Material(
            child: Ink.image(
              image: imageProvider,
              fit: BoxFit.cover,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HeroPhotoViewRouteWrapper(
                      tag: heroTag,
                      imageProvider: imageProvider,
                    );
                  }));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
