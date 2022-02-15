import 'dart:math';

import 'package:flutter/material.dart';

final _random = Random();

String generateRandomString({int len = 10}) {
  return String.fromCharCodes(
    List.generate(
      len,
      (index) => _random.nextInt(33) + 89,
    ),
  );
}

Color getRandomColor(String seed) {
  final colors = [
    Colors.indigo,
    const Color.fromARGB(255, 0, 119, 6),
    Colors.orange,
    Colors.purple,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.cyan,
  ];

  final random = Random(seed.hashCode);
  return colors[random.nextInt(colors.length + 1)];
}
