// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyInfo _$ReplyInfoFromJson(Map<String, dynamic> json) => ReplyInfo(
      replyCount: json['replyCount'] as int?,
      tweetId: json['tweetId'] as String?,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => ReplyUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReplyInfoToJson(ReplyInfo instance) => <String, dynamic>{
      'replyCount': instance.replyCount,
      'tweetId': instance.tweetId,
      'users': instance.users?.map((e) => e.toJson()).toList(),
    };
