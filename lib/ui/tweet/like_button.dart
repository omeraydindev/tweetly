import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/main.dart';
import 'package:tweetly/models/tweet.dart';
import 'package:tweetly/ui/tweet/tweet_widget.dart';

class TweetLikeButton extends StatefulWidget {
  const TweetLikeButton({Key? key, required this.tweet,}) : super(key: key);

  final Tweet tweet;

  @override
  State<TweetLikeButton> createState() => _TweetLikeButtonState();
}

class _TweetLikeButtonState extends State<TweetLikeButton> {

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      size: TweetWidget.iconSize,
      likeCount: widget.tweet.likes.length,
      likeCountPadding: TweetWidget.countPadding,
      likeBuilder: (isLiked) {
        return Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? Colors.pinkAccent : TweetWidget.iconColor,
          size: TweetWidget.iconSize,
        );
      },
      countBuilder: (count, isLiked, text) {
        return Text(
          count != 0 ? text : '',
          style: TweetWidget.countTextStyle,
        );
      },
      isLiked: isTweetLiked(),
      onTap: onLikeButtonTap,
    );
  }

  bool isTweetLiked() {
    final session = MyApp.sessionManager.getSession()!;
    return widget.tweet.likes.contains(session.uid);
  }

  Future<bool?> onLikeButtonTap(bool isLiked) async {
    final session = MyApp.sessionManager.getSession()!;
    await API.likeTweet(session, widget.tweet, !isLiked);
    return !isLiked;
  }
}
