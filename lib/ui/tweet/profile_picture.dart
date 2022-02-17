import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/models/user.dart';
import 'package:tweetly/screens/profile.dart';
import 'package:tweetly/utils/random.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    Key? key,
    required this.user,
    this.clickable = true,
    this.shouldLoad = true,
  }) : super(key: key);

  final User user;
  final bool clickable;
  final bool shouldLoad;

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  static const profilePictureSize = 52.0;

  @override
  Widget build(BuildContext context) {
    final heroTag = generateRandomString();

    return Hero(
      tag: heroTag,
      child: CachedNetworkImage(
        width: profilePictureSize,
        height: profilePictureSize,
        imageUrl: API.getPfpURLForId(widget.user.profilePic),
        imageBuilder: (context, imageProvider) {
          return GestureDetector(
            child: CircleAvatar(
              backgroundImage: imageProvider,
            ),
            onTap: () {
              if (!widget.clickable) return;

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return ProfilePage(
                    cachedUser: widget.user,
                    heroTag: heroTag,
                    imageProvider: imageProvider,
                  );
                },
              ));
            },
          );
        },
        progressIndicatorBuilder: (context, url, downloadProgress) {
          if (widget.shouldLoad) {
            return CircularProgressIndicator(value: downloadProgress.progress);
          } else {
            return const CircleAvatar(child: Icon(Icons.account_circle));
          }
        },
        errorWidget: (context, url, error) {
          return const CircleAvatar(child: Icon(Icons.account_circle));
        },
      ),
    );
  }
}
