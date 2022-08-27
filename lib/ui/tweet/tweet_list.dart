import 'package:flutter/material.dart';
import 'package:tweetly/constants.dart';
import 'package:tweetly/models/tweet.dart';
import 'package:tweetly/screens/thread.dart';
import 'package:tweetly/ui/tweet/tweet_widget.dart';
import 'package:tweetly/utils/route.dart';

class TweetList extends StatefulWidget {
  const TweetList({
    Key? key,
    required this.tweets,
    this.nested = false,
    this.pfpClickable = true,
  }) : super(key: key);

  final List<Tweet> tweets;
  final bool nested;
  final bool pfpClickable;

  @override
  State<TweetList> createState() => _TweetListState();
}

class _TweetListState extends State<TweetList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: widget.nested,
      physics: widget.nested ? const ClampingScrollPhysics() : null,
      padding: const EdgeInsets.only(top: 8),
      separatorBuilder: (context, index) {
        return const Divider(
          color: dividerColor,
        );
      },
      itemCount: widget.tweets.length,
      itemBuilder: (context, index) {
        return Material(
          color: Colors.white,
          child: InkWell(
            child: TweetWidget(
              tweet: widget.tweets[index],
              pfpClickable: widget.pfpClickable,
            ),
            onTap: () => goToThread(widget.tweets[index]),
          ),
        );
      },
    );
  }

  void goToThread(Tweet tweet) {
    Navigator.of(context).push(createRTLSlideRoute(
      page: ThreadPage(
        parentTweet: tweet,
      ),
    ));
  }
}
