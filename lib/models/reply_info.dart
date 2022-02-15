import 'package:json_annotation/json_annotation.dart';

part 'reply_info.g.dart';

@JsonSerializable(explicitToJson: true)
class ReplyInfo {
  final int? replyCount;
  final String? tweetId;
  final List<ReplyUser>? users;

  ReplyInfo({
    this.replyCount,
    this.tweetId,
    this.users,
  });

  factory ReplyInfo.fromJson(Map<String, dynamic> json) =>
      _$ReplyInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ReplyInfoToJson(this);
}

class ReplyUser {
  final String uid;
  final String? username;

  factory ReplyUser.fromJson(Map<String, dynamic> json) => ReplyUser(
        uid: json['uid'],
        username: json['username'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
      };

  ReplyUser({
    required this.uid,
    this.username,
  });
}
