import 'package:flutter/material.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/main.dart';
import 'package:tweetly/models/user.dart';
import 'package:tweetly/ui/tweet/user_list.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab>
    with AutomaticKeepAliveClientMixin<SearchTab> {
  @override
  bool get wantKeepAlive => true;

  Future<List<User>>? _searchFuture;

  @override
  void initState() {
    super.initState();

    _searchFuture = Future.value(API.searchUsers(''));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: buildSearchBar(),
      ),
      body: buildSearchResults(),
    );
  }

  void doSearch(String query) {
    setState(() {
      _searchFuture = Future.value(API.searchUsers(query));
    });
  }

  Widget buildSearchBar() {
    final controller = TextEditingController();

    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: doSearch,
      decoration: InputDecoration(
        hintText: 'Search users',
        hintStyle: const TextStyle(
          color: Color(0xFF536471),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        suffixIcon: GestureDetector(
          child: const Icon(
            Icons.search,
            color: primaryColor,
          ),
          onTap: () => doSearch(controller.text),
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 36),
      ),
    );
  }

  Widget buildSearchResults() {
    return FutureBuilder<List<User>>(
      future: _searchFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          final users = snapshot.data!;

          if (users.isNotEmpty) {
            return UserList(
              users: users,
            );
          } else {
            return const Center(child: Text('No results'));
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error!.toString()));
        } else {
          return const Center(
            child: Text(
              'Search for users by \ntheir usernames or full names',
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }
}
