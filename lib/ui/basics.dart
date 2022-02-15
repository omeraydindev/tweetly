import 'package:flutter/material.dart';

extension Basics on BuildContext {
  void showBasicProgressModal() {
    showGeneralDialog(
      context: this,
      barrierColor: Colors.black12.withOpacity(0.5),
      barrierDismissible: false,
      pageBuilder: (_, __, ___) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void showBasicSnackbar(
    String message, {
    String okButtonText = "OK",
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: okButtonText,
          onPressed: () {},
        ),
      ),
    );
  }

  void showBasicDialog({
    String? title,
    String? message,
    String? okButtonText,
  }) {
    AlertDialog alert = AlertDialog(
      title: title != null ? Text(title) : null,
      content: message != null ? Text(message) : null,
      actions: [
        if (okButtonText != null)
          TextButton(
            child: Text(okButtonText),
            onPressed: () {
              Navigator.of(this).pop();
            },
          )
      ],
    );

    showDialog(
      context: this,
      builder: (context) => alert,
    );
  }
}
