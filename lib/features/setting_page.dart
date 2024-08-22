import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/features/magazine/controller/magazine_controller.dart';
import 'package:magazine/shared/global-widgets/buttons.dart';
import 'package:magazine/shared/global-widgets/dialog_custom.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final cMaga = Get.put(MagazineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan', style: fLg.copyWith(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delete semua terakhir baca'),
              Obx(() {
                return SizedBox(
                  height: 40,
                  width: 100,
                  child: ButtonCustom(
                    padding: 10,
                    onClick: () {
                      if (cMaga.filteredMagazines.isNotEmpty) {
                        DialogCustom.showConfirmationDialog(
                          'Konfirmasi',
                          'Yakin anda ingin menghapus semua terakhir majalah yang dibaca ?',
                          () async {
                            await cMaga.clearAllPagesData();
                          },
                        );
                      }
                    },
                    text: 'Hapus',
                    backgroundColor: cMaga.filteredMagazines.isNotEmpty
                        ? Colors.red
                        : Colors.red.withOpacity(0.3),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
