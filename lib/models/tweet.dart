import 'package:json_annotation/json_annotation.dart';
import 'package:tweetly/models/reply_info.dart';
import 'package:tweetly/models/retweet_info.dart';
import 'package:tweetly/models/user.dart';

part 'tweet.g.dart';

@JsonSerializable(createToJson: false)
class Tweet {
  @JsonKey(name: '_id')
  final String tweetId;

  final User user;
  final String content;
  final DateTime timestamp;
  final List<String> likes;
  final List<String> images;
  final ReplyInfo? replyInfo;
  final RetweetInfo? retweetInfo;

  Tweet({
    required this.tweetId,
    required this.user,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.images,
    this.replyInfo,
    this.retweetInfo,
  });

  factory Tweet.fromJson(Map<String, dynamic> json) => _$TweetFromJson(json);
}
