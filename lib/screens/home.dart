import 'package:flutter/material.dart';
import 'package:tweetly/screens/tabs/feed.dart';
import 'package:tweetly/screens/tabs/my_profile.dart';
import 'package:tweetly/screens/tabs/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedPageIndex;
  late PageController _pageController;
  late List<Widget> _pages;

  final ValueNotifier _createTweetNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _selectedPageIndex = 0;
    _pages = [
      FeedTab(createTweetNotifier: _createTweetNotifier),
      const SearchTab(),
      const Center(child: Text('No notifications')),
      const MyProfileTab(),
    ];
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: _selectedPageIndex == 0 ? buildFAB() : null,
      bottomNavigationBar: buildBottomNavBar(),
      body: PageView(
        controller: _pageController,
        children: _pages,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget buildFAB() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => _createTweetNotifier.value = GlobalKey(),
    );
  }

  Widget buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedPageIndex,
      onTap: (index) => setState(() {
        _selectedPageIndex = index;
        _pageController.jumpToPage(index);
      }),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.portrait),
          label: 'Profile',
        ),
      ],
    );
  }
}
