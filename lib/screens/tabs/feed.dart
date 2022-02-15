import 'package:flutter/material.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/main.dart';
import 'package:tweetly/models/tweet.dart';
import 'package:tweetly/screens/new_tweet.dart';
import 'package:tweetly/ui/tweet/tweet_list.dart';
import 'package:tweetly/ui/tweet/tweet_widget.dart';
import 'package:tweetly/utils/route.dart';

class FeedTab extends StatefulWidget {
  const FeedTab({
    Key? key,
    required this.createTweetNotifier,
  }) : super(key: key);

  final ValueNotifier createTweetNotifier;

  @override
  State<FeedTab> createState() => FeedStateTab();
}

class FeedStateTab extends State<FeedTab>
    with AutomaticKeepAliveClientMixin<FeedTab> {
  @override
  bool get wantKeepAlive => true;

  late Future<List<Tweet>> tweetsFuture;

  @override
  void initState() {
    super.initState();

    // load tweets when Home page first loads
    tweetsFuture = API.fetchTweets(
      MyApp.sessionManager.getSession()!,
    );

    widget.createTweetNotifier.addListener(createTweet);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        SliverAppBar(
          backgroundColor: primaryColor,
          floating: true,
          pinned: false,
          snap: false,
          title: buildTitle(),
        ),
      ],
      body: buildTweetsList(),
    );
  }

  Widget buildTitle() {
    return const Center(
      child: Text(
        "tweet.ly",
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Quicksand',
        ),
      ),
    );
  }

  Widget buildTweetsList() {
    return FutureBuilder<List<Tweet>>(
      future: tweetsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return RefreshIndicator(
            child: TweetList(
              tweets: snapshot.data!,
            ),
            onRefresh: refreshTweets,
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error!.toString()));
        }

        return TweetShimmerBuilder.buildShimmer(context);
      },
    );
  }

  void createTweet() async {
    final result = await Navigator.of(context).push(createBTTSlideRoute(
      page: const NewTweetPage(),
    ));
    if (result is bool && result) {
      await refreshTweets(); // refresh tweets after user posts one
    }
  }

  Future<void> refreshTweets() async {
    setState(() {
      tweetsFuture = API.fetchTweets(
        MyApp.sessionManager.getSession()!,
      );
    });
  }
}
