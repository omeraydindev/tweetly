import 'package:json_annotation/json_annotation.dart';

part 'retweet_info.g.dart';

@JsonSerializable()
class RetweetInfo {
  final String? uid;
  final String? username;
  final String? tweetId;

  RetweetInfo({
    this.uid,
    this.username,
    this.tweetId,
  });

  factory RetweetInfo.fromJson(Map<String, dynamic> json) =>
      _$RetweetInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RetweetInfoToJson(this);
}
