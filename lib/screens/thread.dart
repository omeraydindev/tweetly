import 'package:flutter/material.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/main.dart';
import 'package:tweetly/models/reply_info.dart';
import 'package:tweetly/models/tweet.dart';
import 'package:tweetly/screens/new_tweet.dart';
import 'package:tweetly/ui/tweet/parent_tweet_widget.dart';
import 'package:tweetly/ui/tweet/tweet_list.dart';
import 'package:tweetly/ui/tweet/tweet_widget.dart';
import 'package:tweetly/utils/route.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage({
    Key? key,
    required this.parentTweet,
  }) : super(key: key);

  final Tweet parentTweet;

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  late Future<List<Tweet>> _repliesFuture;

  @override
  void initState() {
    super.initState();

    _repliesFuture = API.fetchTweets(
      MyApp.sessionManager.getSession()!,
      replyingToTweet: widget.parentTweet.tweetId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.grey.shade900,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Thread',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade900,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ParentTweetWidget(
                  tweet: widget.parentTweet,
                ),
                const Divider(color: dividerColor, height: 4),
                buildRepliesList(),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const Divider(color: dividerColor, height: 8),
          buildReplyBox(),
        ],
      ),
    );
  }

  Widget buildReplyBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 4, 6),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Tweet your reply',
          suffixIcon: Icon(
            Icons.camera_alt_outlined,
            color: primaryColor,
          ),
        ),
        readOnly: true,
        onTap: goReplyTweet,
      ),
    );
  }

  void goReplyTweet() async {
    final result = await Navigator.of(context).push(createBTTSlideRoute(
      page: NewTweetPage(
        replyInfo: ReplyInfo(
          tweetId: widget.parentTweet.tweetId,
          users: [
            ...?widget.parentTweet.replyInfo?.users,
            ReplyUser(
              uid: widget.parentTweet.user.uid,
            ),
          ],
        ),
      ),
    ));

    if (result is bool && result) {
      setState(() {
        _repliesFuture = API.fetchTweets(
          MyApp.sessionManager.getSession()!,
          replyingToTweet: widget.parentTweet.tweetId,
        );
      });
    }
  }

  Widget buildRepliesList() {
    return FutureBuilder<List<Tweet>>(
      future: _repliesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return TweetList(
            tweets: snapshot.data!,
            nested: true,
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error!.toString()));
        }

        return TweetShimmerBuilder.buildShimmer(context);
      },
    );
  }
}
