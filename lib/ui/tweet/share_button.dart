import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/models/tweet.dart';
import 'package:tweetly/ui/tweet/tweet_widget.dart';

class TweetShareButton extends StatefulWidget {
  const TweetShareButton({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  final Tweet tweet;

  @override
  State<TweetShareButton> createState() => TweetShareButtonState();
}

class TweetShareButtonState extends State<TweetShareButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: TweetWidget.iconSize,
          height: TweetWidget.iconSize,
          child: IconButton(
            onPressed: share,
            iconSize: TweetWidget.iconSize,
            padding: EdgeInsets.zero,
            icon: Image.asset(
              'images/share.png',
              width: TweetWidget.iconSize,
              height: TweetWidget.iconSize,
              color: TweetWidget.iconColor,
            ),
          ),
        ),
      ],
    );
  }

  void share() {
    Share.share(API.getTweetURLForId(widget.tweet.tweetId));
  }
}
