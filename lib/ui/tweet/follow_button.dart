import 'package:flutter/material.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/main.dart';
import 'package:tweetly/models/user.dart';
import 'package:tweetly/ui/basics.dart';

class FollowButton extends StatefulWidget {
  const FollowButton({
    Key? key,
    required this.user,
    this.editProfileCallback,
    this.onSuccessCallback,
  }) : super(key: key);

  final User user;
  final Function? editProfileCallback;
  final Function? onSuccessCallback;

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    final session = MyApp.sessionManager.getSession()!;

    final isProfileMine = widget.user.uid == session.uid;
    final alreadyFollowing = widget.user.followers.contains(session.uid);
    final canFollow = !isProfileMine && !alreadyFollowing;

    if (isProfileMine && widget.editProfileCallback == null) {
      return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: () => !isProfileMine
          ? follow(widget.user, !alreadyFollowing)
          : widget.editProfileCallback?.call(),
      child: Text(
        canFollow ? 'Follow' : (!isProfileMine ? 'Following' : 'Edit profile'),
        style: TextStyle(
          color: canFollow ? Colors.white : Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        shape: const StadiumBorder(),
        primary: canFollow ? Colors.black : Colors.white,
      ),
    );
  }

  void follow(User user, bool followStatus) {
    // show progress modal
    context.showBasicProgressModal();

    final session = MyApp.sessionManager.getSession()!;
    final future = API.followUser(session, user.uid, followStatus);

    // do follow
    future.then((value) {
      // dismiss progress modal
      Navigator.of(context).pop();

      widget.onSuccessCallback?.call();
    }).catchError((err) {
      // dismiss progress modal
      Navigator.of(context).pop();

      // show error dialog
      context.showBasicDialog(
        title: "Error",
        message: err.toString(),
        okButtonText: "OK",
      );
    });
  }
}
