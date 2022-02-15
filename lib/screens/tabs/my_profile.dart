import 'package:flutter/material.dart';
import 'package:tweetly/main.dart';
import 'package:tweetly/screens/profile.dart';

class MyProfileTab extends StatefulWidget {
  const MyProfileTab({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProfileTab> createState() => MyProfileTabState();
}

class MyProfileTabState extends State<MyProfileTab>
    with AutomaticKeepAliveClientMixin<MyProfileTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final session = MyApp.sessionManager.getSession()!;
    return ProfilePage.of(session.uid, showAppbar: false);
  }
}
