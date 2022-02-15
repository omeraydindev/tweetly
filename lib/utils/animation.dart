import 'package:flutter/material.dart';

class AnimationUtils {
  static Widget nonCenteredLayoutBuilder(
      Widget? currentChild, List<Widget> previousChildren) {
    return Stack(
      // alignment: Alignment.center, // we don't want widgets in the animation to be centered
      children: [
        ...previousChildren,
        if (currentChild != null) currentChild,
      ],
    );
  }
}
