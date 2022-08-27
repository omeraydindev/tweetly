import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tweetly/constants.dart';
import 'package:tweetly/models/tweet.dart';
import 'package:tweetly/screens/user_list.dart';
import 'package:tweetly/ui/tweet/images_grid.dart';
import 'package:tweetly/ui/tweet/profile_picture.dart';
import 'package:tweetly/ui/tweet/retweet_indicator.dart';
import 'package:tweetly/utils/route.dart';

class ParentTweetWidget extends StatefulWidget {
  const ParentTweetWidget({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  final Tweet tweet;

  @override
  State<ParentTweetWidget> createState() => _ParentTweetWidgetState();
}

class _ParentTweetWidgetState extends State<ParentTweetWidget> {
  @override
  Widget build(BuildContext context) {
    final isReplyingTo = widget.tweet.replyInfo != null &&
        (widget.tweet.replyInfo?.users?.isNotEmpty ?? false);
    final isRetweet = widget.tweet.retweetInfo != null;

    return Padding(
      padding: const EdgeInsets.all(11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRetweet)
            RetweetIndicator(retweetInfo: widget.tweet.retweetInfo!),
          if (isRetweet) const SizedBox(height: 5),
          buildHeader(),
          const SizedBox(height: 12),
          if (isReplyingTo) buildReplyingTo(),
          if (isReplyingTo) const SizedBox(height: 8),
          buildContent(),
          const SizedBox(height: 12),
          buildDateTime(),
          const SizedBox(height: 8),
          const Divider(color: dividerColor, height: 4),
          const SizedBox(height: 8),
          buildFooter(),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfilePicture(user: widget.tweet.user),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFullName(),
            const SizedBox(height: 2),
            buildUsername(),
          ],
        ),
      ],
    );
  }

  Widget buildFullName() {
    return Text(
      widget.tweet.user.fullName,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildUsername() {
    return Text(
      '@' + widget.tweet.user.username,
      style: TextStyle(
        fontFamily: GoogleFonts.lato().fontFamily,
        fontSize: 16,
        color: Colors.blueGrey.shade700,
      ),
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
          fontSize: 15,
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
        Text(
          widget.tweet.content,
          style: const TextStyle(fontSize: 22.5),
        ),
        if (widget.tweet.images.isNotEmpty)
          Column(
            children: [
              const SizedBox(height: 15),
              ImagesGrid(
                images: widget.tweet.images,
              ),
            ],
          ),
      ],
    );
  }

  Widget buildDateTime() {
    final date = widget.tweet.timestamp;
    final formattedDate =
        DateFormat.jm().format(date) + ' · ' + DateFormat.yMMMd().format(date);

    return Text(
      formattedDate,
      style: TextStyle(
        fontSize: 15,
        color: Colors.blueGrey.shade800,
      ),
    );
  }

  Widget buildFooter() {
    const boldTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );
    final fontTextStyle = TextStyle(
      fontFamily: GoogleFonts.lato().fontFamily,
    );
    final likeCount = widget.tweet.likes.length.toString();

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        children: [
          TextSpan(
            text: likeCount,
            style: boldTextStyle,
          ),
          TextSpan(
            text: ' Likes',
            style: fontTextStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).push(createRTLSlideRoute(
                  page: UserListPage(
                    title: 'Liked by',
                    userUids: widget.tweet.likes,
                  ),
                ));
              },
          ),
        ],
      ),
    );
  }
}
