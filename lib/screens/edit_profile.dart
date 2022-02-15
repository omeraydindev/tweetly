import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/main.dart';
import 'package:tweetly/models/user.dart';
import 'package:tweetly/ui/basics.dart';
import 'package:tweetly/utils/random.dart';
import 'package:tweetly/utils/validators.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const imageSize = 80.0;
  static const imageBgHeight = 120.0 - kToolbarHeight;

  final _formKey = GlobalKey<FormState>();
  final _pickedPfpNotifier = ValueNotifier<XFile?>(null);

  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _fullNameController.text = widget.user.fullName;
    _usernameController.text = widget.user.username;
    _bioController.text = widget.user.bio;
    _emailController.text = widget.user.email;
  }

  void pickProfilePicture() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    var image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    if (image == null) return;

    _pickedPfpNotifier.value = image;
  }

  void save() {
    // validate input
    if (!_formKey.currentState!.validate()) return;

    // show progress modal
    context.showBasicProgressModal();

    // create tweet info
    final session = MyApp.sessionManager.getSession()!;
    final future = API.editProfile(
      session: session,
      profilePhoto: _pickedPfpNotifier.value,
      fullName: _fullNameController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      email: _emailController.text,
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
      if (err is Future) {
        err.then((value) {
          context.showBasicDialog(
            title: "Error",
            message: value.toString(),
            okButtonText: "OK",
          );
        });
      } else {
        context.showBasicDialog(
          title: "Error",
          message: err.toString(),
          okButtonText: "OK",
        );
      }
    });
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
        title: Text(
          'Edit profile',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade900,
          ),
        ),
        actions: [
          buildSaveButton(),
        ],
      ),
      body: ListView(
        children: [
          buildHeader(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildFullNameField(),
                  const SizedBox(height: 8),
                  buildUsernameField(),
                  const SizedBox(height: 8),
                  buildBioField(),
                  const SizedBox(height: 8),
                  buildEmailField(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSaveButton() {
    return Material(
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
        ),
        onTap: save,
      ),
    );
  }

  Widget buildHeader() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Column(
          children: [
            Container(
              color: getRandomColor(widget.user.uid),
              height: imageBgHeight,
            ),
            Container(
              color: Colors.white,
              height: imageSize / 2,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            child: buildProfilePicture(),
            onTap: pickProfilePicture,
          ),
        ),
      ],
    );
  }

  Widget buildProfilePicture() {
    Widget buildImage(BuildContext context, ImageProvider imageProvider) {
      return CircleAvatar(
        backgroundColor: Colors.white,
        radius: imageSize / 2,
        child: Stack(
          children: [
            CircleAvatar(
              backgroundImage: imageProvider,
              radius: imageSize / 2 - 4,
            ),
            const CircleAvatar(
              radius: imageSize / 2 - 4,
              backgroundColor: Color.fromARGB(120, 0, 0, 0),
              child: Icon(
                Icons.camera_enhance_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      );
    }

    return ValueListenableBuilder<XFile?>(
      valueListenable: _pickedPfpNotifier,
      builder: (context, value, child) {
        if (value == null) {
          return CachedNetworkImage(
            imageUrl: API.getPfpURLForId(widget.user.profilePic),
            imageBuilder: buildImage,
          );
        } else {
          return buildImage(
            context,
            FileImage(File(value.path)),
          );
        }
      },
    );
  }

  Widget buildFullNameField() {
    return TextFormField(
      controller: _fullNameController,
      validator: fullNameValidator(),
      decoration: const InputDecoration(
        label: Text('Full name'),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      validator: usernameValidator(),
      decoration: const InputDecoration(
        label: Text('Username'),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget buildBioField() {
    return TextFormField(
      controller: _bioController,
      validator: bioValidator(),
      minLines: 2,
      maxLines: 4,
      decoration: const InputDecoration(
        label: Text('Bio'),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      controller: _emailController,
      validator: emailValidator(),
      decoration: const InputDecoration(
        label: Text('Email'),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
