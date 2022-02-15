import 'package:flutter/material.dart';
import 'package:tweetly/models/retweet_info.dart';
import 'package:tweetly/screens/profile.dart';
import 'package:tweetly/utils/route.dart';

class RetweetIndicator extends StatefulWidget {
  const RetweetIndicator({
    Key? key, required this.retweetInfo,
  }) : super(key: key);

  final RetweetInfo retweetInfo;

  @override
  State<RetweetIndicator> createState() => _RetweetIndicatorState();
}

class _RetweetIndicatorState extends State<RetweetIndicator> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 52 - 16),
      child: Row(
        children: [
          Image.asset(
            'images/retweet.png',
            width: 16,
            height: 16,
            color: Colors.blueGrey.shade900,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: GestureDetector(
              child: Text(
                widget.retweetInfo.username! + ' Retweeted',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade900,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(createRTLSlideRoute(
                  page: ProfilePage.of(widget.retweetInfo.uid!),
                ));
              },
            ),
          )
        ],
      ),
    );
  }
}
