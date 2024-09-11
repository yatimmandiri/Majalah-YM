import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogCustom {
  static void showConfirmationDialog(String title, String message,
      void Function() onPressed, bool visibility) {
    Get.dialog(
      Stack(
        children: [
          Visibility(
            visible: visibility,
            child: Positioned(
              top: 145,
              right: -10,
              child: Image.asset(
                'assets/images/info.png',
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
          ),
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
        ],
      ),
    );
  }
}
