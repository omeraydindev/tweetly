import 'package:flutter/material.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/models/user.dart';
import 'package:tweetly/ui/tweet/user_list.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({
    Key? key,
    required this.title,
    required this.userUids,
  }) : super(key: key);

  final String title;
  final List<String> userUids;

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late final Future<List<User>> users;

  @override
  void initState() {
    super.initState();

    users = getUsers();
  }

  Future<List<User>> getUsers() async {
    final list = <User>[];
    for (var userUid in widget.userUids) {
      final user = await API.getUserInfo(userUid); // todo: do this server-side
      list.add(user);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.grey.shade900,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade900,
          ),
        ),
      ),
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return UserList(
              users: snapshot.data!,
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
