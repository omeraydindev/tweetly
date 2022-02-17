import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tweetly/main.dart';
import 'package:tweetly/models/tweet.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tweetly/models/user.dart';
import 'package:tweetly/ui/tweet/images_grid.dart';
import 'package:tweetly/ui/tweet/like_button.dart';
import 'package:tweetly/ui/tweet/profile_picture.dart';
import 'package:tweetly/ui/tweet/retweet_button.dart';
import 'package:tweetly/ui/tweet/retweet_indicator.dart';
import 'package:tweetly/ui/tweet/share_button.dart';

part 'tweet_shimmer.dart';

class TweetWidget extends StatefulWidget {
  const TweetWidget({
    Key? key,
    required this.tweet,
    this.pfpClickable = true,
    this.pfpShouldLoad = true,
    this.headerBuilder,
    this.contentBuilder,
    this.footerBuilder,
  }) : super(key: key);

  static const iconColor = Color(0xFF536471);
  static const iconSize = 18.0;
  static const countPadding = EdgeInsets.only(left: 8);
  static const countTextStyle = TextStyle(
    color: iconColor,
    fontSize: 13,
  );

  final Tweet tweet;
  final bool pfpClickable;
  final bool pfpShouldLoad;
  final ValueGetter<Widget>? headerBuilder;
  final ValueGetter<Widget>? contentBuilder;
  final ValueGetter<Widget>? footerBuilder;

  @override
  State<TweetWidget> createState() => _TweetWidgetState();
}

class _TweetWidgetState extends State<TweetWidget> {
  @override
  Widget build(BuildContext context) {
    final isReplyingTo = widget.tweet.replyInfo != null &&
        (widget.tweet.replyInfo?.users?.isNotEmpty ?? false);
    final isRetweet = widget.tweet.retweetInfo != null;

    final tweetWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildProfilePicture(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (widget.headerBuilder ?? buildHeader)(),
              const SizedBox(height: 5),
              if (isReplyingTo) buildReplyingTo(),
              if (isReplyingTo) const SizedBox(height: 5),
              (widget.contentBuilder ?? buildContent)(),
              const SizedBox(height: 8),
              (widget.footerBuilder ?? buildFooter)(),
            ],
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRetweet)
            RetweetIndicator(retweetInfo: widget.tweet.retweetInfo!),
          if (isRetweet) const SizedBox(height: 5),
          tweetWidget,
        ],
      ),
    );
  }

  Widget buildProfilePicture() {
    return ProfilePicture(
      user: widget.tweet.user,
      clickable: widget.pfpClickable,
      shouldLoad: widget.pfpShouldLoad,
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        Text(
          widget.tweet.user.fullName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
          ),
        ),
        Text(
          " @" + widget.tweet.user.username,
          style: TextStyle(
            color: Colors.blueGrey.shade700,
          ),
        ),
        Text(
            " · " + timeago.format(widget.tweet.timestamp, locale: 'en_short')),
      ],
    );
  }

  Widget buildReplyingTo() {
    var list = widget.tweet.replyInfo!.users!
        .map((e) => '@' + e.username!)
        .toSet()
        .toList();

    String replyText;
    if (list.length == 1) {
      replyText = list.first;
    } else {
      String last = list.removeAt(list.length - 1);
      replyText = list.join(' ') + ' and ' + last;
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.blueGrey.shade700,
        ),
        children: [
          const TextSpan(text: 'Replying to '),
          TextSpan(
            text: replyText,
            style: const TextStyle(
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.tweet.content),
        if (widget.tweet.images.isNotEmpty)
          Column(
            children: [
              const SizedBox(height: 8),
              ImagesGrid(
                images: widget.tweet.images,
              ),
            ],
          ),
      ],
    );
  }

  Widget buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildReplyButton(),
        TweetRetweetButton(tweet: widget.tweet),
        TweetLikeButton(tweet: widget.tweet),
        TweetShareButton(tweet: widget.tweet),
      ],
    );
  }

  Widget buildReplyButton() {
    final count = widget.tweet.replyInfo?.replyCount?.toString() ?? '';

    return Row(
      children: [
        Image.asset(
          'images/reply.png',
          width: TweetWidget.iconSize,
          height: TweetWidget.iconSize,
          color: TweetWidget.iconColor,
        ),
        Padding(
          padding: TweetWidget.countPadding,
          child: Text(
            count != '0' ? count : '',
            style: TweetWidget.countTextStyle,
          ),
        ),
      ],
    );
  }
}
