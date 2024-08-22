import 'package:flutter/material.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/features/notification/widgets/notif_card.dart';

class NotifPage extends StatelessWidget {
  const NotifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: fLg.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              NotifCard(
                title:
                    '9 Cara Mengajarkan Sopan Santun pada Anak, Mudah & Efektif!',
              )
            ],
          ),
        ),
      ),
    );
  }
}
