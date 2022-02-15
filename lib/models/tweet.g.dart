// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tweet _$TweetFromJson(Map<String, dynamic> json) => Tweet(
      tweetId: json['_id'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      likes: (json['likes'] as List<dynamic>).map((e) => e as String).toList(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      replyInfo: json['replyInfo'] == null
          ? null
          : ReplyInfo.fromJson(json['replyInfo'] as Map<String, dynamic>),
      retweetInfo: json['retweetInfo'] == null
          ? null
          : RetweetInfo.fromJson(json['retweetInfo'] as Map<String, dynamic>),
    );
