import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tweetly/models/login_register.dart';
import 'package:tweetly/api/session.dart';
import 'package:tweetly/models/reply_info.dart';

import 'package:tweetly/models/tweet.dart';
import 'package:tweetly/constants.dart';
import 'package:tweetly/models/user.dart';

class API {
  // User

  static Future<User> getUserInfo(String uid) async {
    final response = await http.post(
      Uri.parse(host + "/get_user_info"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'uid': uid,
      }),
    );

    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));

      return user;
    }
    throw response.body;
  }

  static Future<void> editProfile({
    required Session session,
    XFile? profilePhoto,
    required String fullName,
    required String username,
    required String bio,
    required String email,
  }) async {
    final uri = Uri.parse(host + '/edit_profile');
    final request = http.MultipartRequest('POST', uri);

    if (profilePhoto != null) {
      final file = await http.MultipartFile.fromPath(
        'image',
        profilePhoto.path,
        contentType: MediaType(
          'image',
          profilePhoto.path.split('.').last,
        ),
      );
      request.files.add(file);
    }

    request.headers['X-Access-Token'] = session.token;
    request.fields['fullName'] = fullName;
    request.fields['username'] = username;
    request.fields['bio'] = bio;
    request.fields['email'] = email;

    final response = await request.send();

    if (response.statusCode == 200) {
      // don't do anything
    } else {
      throw response.stream.bytesToString();
    }
  }

  static Future<List<User>> searchUsers(String query) async {
    final response = await http.post(
      Uri.parse(host + "/search_users"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'query': query,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);

      return body.map((e) => User.fromJson(e)).toList();
    }
    throw response.body;
  }

  static Future<void> followUser(
      Session session, String uid, bool followStatus) async {
    final response = await http.post(
      Uri.parse(host + "/follow_user"),
      headers: {
        'X-Access-Token': session.token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'uid': uid,
        'followStatus': followStatus.toString(),
      }),
    );

    if (response.statusCode == 200) {
      // do nothing
    } else {
      throw response.body;
    }
  }

  // Tweets

  static Future<List<Tweet>> fetchTweets(
    Session session, {
    String? uid,
    String? replyingToTweet, // tweet id
  }) async {
    final response = await http.post(
      Uri.parse(host + "/fetch_tweets"),
      headers: {
        'X-Access-Token': session.token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'uid': uid,
        'replyingToTweet': replyingToTweet,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);

      return body.map((e) => Tweet.fromJson(e)).toList();
    }
    throw response.body;
  }

  static Future<void> postTweet({
    required Session session,
    required String content,
    required List<XFile> images,
    ReplyInfo? replyInfo,
  }) async {
    final uri = Uri.parse(host + '/post_tweet');
    final request = http.MultipartRequest('POST', uri);

    // add images
    for (final image in images) {
      final file = await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType(
          'image',
          image.path.split('.').last,
        ),
      );
      request.files.add(file);
    }

    request.headers['X-Access-Token'] = session.token;
    request.fields['content'] = content;
    if (replyInfo != null) {
      request.fields['replyInfo'] = jsonEncode(replyInfo.toJson());
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      // don't do anything
    } else {
      throw response.stream.bytesToString();
    }
  }

  static Future<void> likeTweet(
      Session session, Tweet tweet, bool likeStatus) async {
    final response = await http.post(
      Uri.parse(host + "/like_tweet"),
      headers: {
        'X-Access-Token': session.token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tweet_id': tweet.tweetId,
        'like_status': likeStatus.toString(),
      }),
    );

    if (response.statusCode == 200) {
      jsonDecode(response.body);

      // don't do anything
    } else {
      throw response.body;
    }
  }

  static Future<void> retweet(Session session, Tweet tweet) async {
    final response = await http.post(
      Uri.parse(host + "/retweet"),
      headers: {
        'X-Access-Token': session.token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tweetId': tweet.tweetId,
      }),
    );

    if (response.statusCode == 200) {
      // don't do anything
    } else {
      throw response.body;
    }
  }

  static String getTweetURLForId(String tweetId) {
    return '$host/tweet/$tweetId';
  }

  static String getImageURLForId(String imageId) {
    return '$host/get_image/$imageId';
  }

  static String getPfpURLForId(String imageId) {
    return '$host/get_profile_pic/$imageId';
  }

  // Authentication

  static Future<Session> registerUser(LoginRegisterInfo info) async {
    final response = await http.post(
      Uri.parse(host + "/register"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: info.toJson(),
    );

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);

      return Session(
        uid: body['_id'],
        token: body['token'],
      );
    }
    throw response.body;
  }

  static Future<Session> loginUser(LoginRegisterInfo info) async {
    final response = await http.post(
      Uri.parse(host + "/login"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: info.toJson(),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      return Session(
        uid: body['_id'],
        token: body['token'],
      );
    }
    throw response.body;
  }
}
