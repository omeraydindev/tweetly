import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(createToJson: false)
class User {
  @JsonKey(name: '_id')
  final String uid;

  final String fullName;
  final String username;
  final String email;
  final String profilePic;
  final String bio;
  final List<String> followers;
  final List<String> followed;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.profilePic,
    required this.fullName,
    this.bio = '',
    this.followers = const [],
    this.followed = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
