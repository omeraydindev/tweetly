import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/main.dart';
import 'package:tweetly/models/tweet.dart';
import 'package:tweetly/models/user.dart';
import 'package:tweetly/screens/edit_profile.dart';
import 'package:tweetly/screens/user_list.dart';
import 'package:tweetly/screens/view_photo.dart';
import 'package:tweetly/ui/tweet/follow_button.dart';
import 'package:tweetly/ui/tweet/tweet_list.dart';
import 'package:tweetly/ui/tweet/tweet_widget.dart';
import 'package:tweetly/utils/random.dart';
import 'package:tweetly/utils/route.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.cachedUser,
    this.heroTag,
    this.imageProvider,
    this.showAppbar = true,
  }) : super(key: key);

  factory ProfilePage.of(String uid, {bool showAppbar = true}) {
    return ProfilePage(
      cachedUser: User(
        uid: uid,
        username: '',
        profilePic: '',
        email: '',
        fullName: '',
      ),
      showAppbar: showAppbar,
    );
  }

  final User cachedUser;
  final String? heroTag;
  final ImageProvider? imageProvider;
  final bool showAppbar;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const imageSize = 80.0;
  static const imageBgHeight = 120.0 - kToolbarHeight;

  late Future<User> _freshUserFuture;
  late Future<List<Tweet>> _tweetsFuture;

  @override
  void initState() {
    super.initState();

    _freshUserFuture = API.getUserInfo(widget.cachedUser.uid);
    _tweetsFuture = API.fetchTweets(
      MyApp.sessionManager.getSession()!,
      uid: widget.cachedUser.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: getRandomColor(widget.cachedUser.uid),
        toolbarHeight: !widget.showAppbar ? 0 : null,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: RefreshIndicator(
          child: buildBody(),
          onRefresh: refresh,
        ),
      ),
    );
  }

  Future<void> refresh() async {
    final user = await API.getUserInfo(widget.cachedUser.uid);

    setState(() {
      _freshUserFuture = Future.value(user);
      _tweetsFuture = API.fetchTweets(
        MyApp.sessionManager.getSession()!,
        uid: widget.cachedUser.uid,
      );
    });
  }

  Widget buildBody() {
    return ListView(
      children: [
        buildHeader(),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFullName(),
              const SizedBox(height: 2),
              buildUsername(),
              const SizedBox(height: 18),
              buildBio(),
              const SizedBox(height: 18),
              buildFollowerInfo(),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Divider(color: dividerColor, height: 8),
        buildTweetsList(),
      ],
    );
  }

  Widget buildHeader() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Column(
          children: [
            Container(
              color: getRandomColor(widget.cachedUser.uid),
              height: imageBgHeight,
            ),
            Container(
              color: Colors.white,
              height: imageSize / 2 + 14,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: buildFollowButton(),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 14),
          child: buildProfilePicture(),
        ),
      ],
    );
  }

  Widget buildProfilePicture() {
    Widget buildImage(BuildContext context, ImageProvider imageProvider) {
      return GestureDetector(
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: imageSize / 2,
          child: CircleAvatar(
            backgroundImage: imageProvider,
            radius: imageSize / 2 - 4,
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HeroPhotoViewRouteWrapper(
              tag: widget.heroTag ?? '',
              imageProvider: imageProvider,
            );
          }));
        },
      );
    }

    return FutureBuilder<User>(
      future: _freshUserFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Hero(
            tag: widget.heroTag ?? '',
            child: CachedNetworkImage(
              imageUrl: API.getPfpURLForId(snapshot.data!.profilePic),
              imageBuilder: buildImage,
            ),
          );
        } else if (widget.imageProvider != null) {
          return Hero(
            tag: widget.heroTag ?? '',
            child: buildImage(context, widget.imageProvider!),
          );
        }
        return Container();
      },
    );
  }

  Widget buildFullName() {
    return FutureBuilder<User>(
      future: _freshUserFuture,
      builder: (context, snapshot) {
        return Text(
          snapshot.hasData
              ? snapshot.data!.fullName
              : widget.cachedUser.fullName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  Widget buildUsername() {
    return FutureBuilder<User>(
      future: _freshUserFuture,
      builder: (context, snapshot) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '@' +
                  (snapshot.hasData
                      ? snapshot.data!.username
                      : widget.cachedUser.username),
              style: TextStyle(
                fontFamily: GoogleFonts.lato().fontFamily,
                fontSize: 16,
                color: Colors.blueGrey.shade700,
              ),
            ),
            buildFollowsYouText(),
          ],
        );
      },
    );
  }

  Widget buildFollowsYouText() {
    return FutureBuilder<User>(
      future: _freshUserFuture,
      builder: (context, snapshot) {
        final session = MyApp.sessionManager.getSession()!;
        final isFollowingMe =
            snapshot.hasData && snapshot.data!.followed.contains(session.uid);
        if (!isFollowingMe) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            color: Colors.grey.shade200,
            child: Text(
              'Follows you',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey.shade700,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildBio() {
    return FutureBuilder<User>(
      future: _freshUserFuture,
      builder: (context, snapshot) {
        return Text(
          snapshot.hasData ? snapshot.data!.bio : widget.cachedUser.bio,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade900,
          ),
        );
      },
    );
  }

  Widget buildFollowerInfo() {
    const boldTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );
    final fontTextStyle = TextStyle(
      fontFamily: GoogleFonts.lato().fontFamily,
    );

    return FutureBuilder<User>(
      future: _freshUserFuture,
      builder: (context, snapshot) {
        final followed =
            snapshot.hasData ? snapshot.data!.followed.length.toString() : '0';
        final followers =
            snapshot.hasData ? snapshot.data!.followers.length.toString() : '0';

        return RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            children: [
              TextSpan(
                text: followed,
                style: boldTextStyle,
              ),
              TextSpan(
                text: ' Following',
                style: fontTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).push(createRTLSlideRoute(
                      page: UserListPage(
                        title: 'Following',
                        userUids: snapshot.data!.followed,
                      ),
                    ));
                  },
              ),
              TextSpan(
                text: ' • ' + followers,
                style: boldTextStyle,
              ),
              TextSpan(
                text: ' Followers',
                style: fontTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).push(createRTLSlideRoute(
                      page: UserListPage(
                        title: 'Followers',
                        userUids: snapshot.data!.followers,
                      ),
                    ));
                  },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildFollowButton() {
    return FutureBuilder<User>(
      future: _freshUserFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final user = snapshot.data!;

        return FollowButton(
          user: user,
          editProfileCallback: () => goEditProfile(user),
          onSuccessCallback: () {
            setState(() {
              _freshUserFuture = Future.value(API.getUserInfo(user.uid));
            });
          },
        );
      },
    );
  }

  void goEditProfile(User user) async {
    final result = await Navigator.of(context).push(createBTTSlideRoute(
      page: EditProfilePage(
        user: user,
      ),
    ));
    if (result is bool && result) {
      await refresh(); // refresh profile
    }
  }

  Widget buildTweetsList() {
    return FutureBuilder<List<Tweet>>(
      future: _tweetsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return TweetList(
            tweets: snapshot.data!,
            nested: true,
            pfpClickable: false,
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error!.toString()));
        }

        return TweetShimmerBuilder.buildShimmer(context);
      },
    );
  }
}
