// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      uid: json['_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      profilePic: json['profilePic'] as String,
      fullName: json['fullName'] as String,
      bio: json['bio'] as String? ?? '',
      followers: (json['followers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      followed: (json['followed'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
