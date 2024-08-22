import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogCustom {
  static void showConfirmationDialog(String title,
      String message, void Function() onPressed) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              onPressed();
              Get.back();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
