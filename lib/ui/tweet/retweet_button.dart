import 'package:flutter/material.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/main.dart';
import 'package:tweetly/models/tweet.dart';
import 'package:tweetly/ui/basics.dart';
import 'package:tweetly/ui/tweet/tweet_widget.dart';

class TweetRetweetButton extends StatefulWidget {
  const TweetRetweetButton({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  final Tweet tweet;

  @override
  State<TweetRetweetButton> createState() => _TweetRetweetButtonState();
}

class _TweetRetweetButtonState extends State<TweetRetweetButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: TweetWidget.iconSize,
          height: TweetWidget.iconSize,
          child: IconButton(
            onPressed: retweet,
            iconSize: TweetWidget.iconSize,
            padding: EdgeInsets.zero,
            icon: Image.asset(
              'images/retweet.png',
              width: TweetWidget.iconSize,
              height: TweetWidget.iconSize,
              color: TweetWidget.iconColor,
            ),
          ),
        ),
      ],
    );
  }

  void retweet() async {
    // show progress modal
    context.showBasicProgressModal();

    final session = MyApp.sessionManager.getSession()!;
    final future = API.retweet(session, widget.tweet);

    future.then((value) {
      // dismiss progress modal
      Navigator.of(context).pop();

      context.showBasicSnackbar('Retweet successful, you can refresh');
    }).catchError((error) {
      // dismiss progress modal
      Navigator.of(context).pop();

      context.showBasicDialog(
        title: "Error",
        message: error.toString(),
        okButtonText: "OK",
      );
    });
  }
}
