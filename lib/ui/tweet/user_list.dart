import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tweetly/main.dart';
import 'package:tweetly/models/user.dart';
import 'package:tweetly/screens/profile.dart';
import 'package:tweetly/ui/tweet/profile_picture.dart';
import 'package:tweetly/utils/route.dart';

class UserList extends StatefulWidget {
  const UserList({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List<User> users;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 10),
      itemCount: widget.users.length,
      separatorBuilder: (context, index) {
        return const Divider(
          color: dividerColor,
        );
      },
      itemBuilder: (context, index) {
        return Material(
          child: InkWell(
            child: UserListItem(user: widget.users[index]),
            onTap: () => goToUser(widget.users[index]),
          ),
        );
      },
    );
  }

  void goToUser(User user) {
    Navigator.of(context).push(createRTLSlideRoute(
      page: ProfilePage.of(user.uid),
    ));
  }
}

class UserListItem extends StatefulWidget {
  const UserListItem({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfilePicture(
            user: widget.user,
            clickable: false,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFullName(),
              const SizedBox(height: 2),
              buildUsername(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFullName() {
    return Text(
      widget.user.fullName,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildUsername() {
    return Text(
      '@' + widget.user.username,
      style: TextStyle(
        fontFamily: GoogleFonts.lato().fontFamily,
        fontSize: 16,
        color: Colors.blueGrey.shade700,
      ),
    );
  }
}
