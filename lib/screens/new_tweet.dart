import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/main.dart';
import 'package:tweetly/models/reply_info.dart';
import 'package:tweetly/ui/basics.dart';

class NewTweetPage extends StatefulWidget {
  const NewTweetPage({
    Key? key,
    this.replyInfo,
  }) : super(key: key);

  final ReplyInfo? replyInfo;

  @override
  _NewTweetPageState createState() => _NewTweetPageState();
}

class _NewTweetPageState extends State<NewTweetPage> {
  final _tweetFieldController = TextEditingController();
  final _tweetProgressNotifier = ValueNotifier(0.0);
  final _pickedImagesNotifier = ValueNotifier(<XFile>[]);

  @override
  void initState() {
    super.initState();

    _tweetFieldController.addListener(updateTweetProgressBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.grey.shade900,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          buildPostTweetButton(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: buildTweetTextField(),
          ),
          buildPickedImagesRow(),
          buildFooter(),
        ],
      ),
    );
  }

  void postTweet() {
    if (_tweetFieldController.text.isEmpty) return;

    // show progress modal
    context.showBasicProgressModal();

    // create tweet info
    final session = MyApp.sessionManager.getSession()!;
    final future = API.postTweet(
      session: session,
      content: _tweetFieldController.text,
      images: _pickedImagesNotifier.value,
      replyInfo: widget.replyInfo,
    );

    // post tweet
    future.then((value) {
      // dismiss progress modal
      Navigator.of(context).pop();

      // go back
      Navigator.of(context).pop(true);
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

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    var images = await _picker.pickMultiImage(
      imageQuality: 40,
    );

    if (images == null || images.isEmpty) return;
    if (images.length > 4) {
      context.showBasicSnackbar("You can pick up to 4 images per tweet");
      images = images.sublist(0, 4);
    }

    _pickedImagesNotifier.value = images;
  }

  void updateTweetProgressBar() {
    double progress = _tweetFieldController.text.length / maxTweetLength;
    _tweetProgressNotifier.value = progress;
  }

  Widget buildPostTweetButton() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ElevatedButton(
        onPressed: postTweet,
        child: const Text(
          'Tweet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          shape: const StadiumBorder(),
          primary: primaryColor,
        ),
      ),
    );
  }

  Widget buildTweetTextField() {
    return TextField(
      decoration: InputDecoration(
        hintText:
            widget.replyInfo == null ? "What's happening?" : "Tweet your reply",
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      ),
      style: const TextStyle(
        fontSize: 20,
      ),
      autofocus: true,
      expands: true,
      minLines: null,
      maxLines: null,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxTweetLength),
      ],
      controller: _tweetFieldController,
    );
  }

  Widget buildPickedImagesRow() {
    Widget buildPickedImageItem(XFile image) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: Image.file(
              File(image.path),
              width: 50,
              height: 50,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            child: const Icon(
              Icons.close,
              size: 16,
              color: Colors.red,
            ),
          )
        ],
      );
    }

    return ValueListenableBuilder(
      valueListenable: _pickedImagesNotifier,
      builder: (context, List<XFile> pickedImages, child) {
        return Row(
          children: [
            for (var image in pickedImages)
              IconButton(
                padding: EdgeInsets.zero,
                icon: buildPickedImageItem(image),
                onPressed: () {
                  pickedImages.remove(image);
                  _pickedImagesNotifier.value = [...pickedImages];
                },
              ),
          ],
        );
      },
    );
  }

  Widget buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildPickImageButton(),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: buildTweetProgressBar(),
        ),
      ],
    );
  }

  Widget buildPickImageButton() {
    return TextButton.icon(
      onPressed: pickImage,
      icon: const Icon(
        Icons.image_outlined,
        color: primaryColor,
      ),
      label: const Text(
        'Add image(s)',
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildTweetProgressBar() {
    return ValueListenableBuilder(
      valueListenable: _tweetProgressNotifier,
      builder: (context, double value, child) {
        return SizedBox(
          width: 30,
          height: 30,
          child: Center(
            child: CircularProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
        );
      },
    );
  }
}
