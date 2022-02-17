part of 'tweet_widget.dart';

class TweetShimmerBuilder {
  static final shimmerBaseColor = Colors.grey.shade300;
  static final shimmerHighlightColor = Colors.grey.shade100;

  static Widget buildShimmer(BuildContext context) {
    final mockTweet = Tweet(
      content: '',
      likes: [],
      images: [],
      timestamp: DateTime.now(),
      tweetId: '',
      user: User(
        email: '',
        fullName: '',
        profilePic: '',
        uid: '',
        username: '',
      ),
    );

    final mockTweetWidget = TweetWidget(
      tweet: mockTweet,
      pfpShouldLoad: false,
      headerBuilder: () {
        return Column(
          children: [
            Container(height: 4),
            Container(
              color: Colors.black,
              width: double.infinity,
              height: 8,
            ),
          ],
        );
      },
      contentBuilder: () {
        return Column(
          children: [
            Container(height: 4),
            Container(
              color: Colors.black,
              width: double.infinity,
              height: 8,
            ),
            Container(height: 4),
            Container(
              color: Colors.black,
              width: double.infinity,
              height: 8,
            ),
            Container(height: 2),
          ],
        );
      },
    );

    const itemCount = 7;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: List.generate(
          itemCount * 2 - 1,
          (index) {
            if (index % 2 == 1) {
              return const Divider(
                color: dividerColor,
              );
            } else {
              return Shimmer.fromColors(
                child: mockTweetWidget,
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
              );
            }
          },
        ),
      ),
    );
  }
}
