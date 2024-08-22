import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/config/endpoints.dart';
import 'package:magazine/features/magazine/controller/magazine_controller.dart';
import 'package:magazine/features/magazine/data/model/magazine_model.dart';
import 'package:magazine/features/magazine/view/widgets/magazine_card.dart';
import 'package:magazine/shared/global-widgets/blank_item.dart';
import 'package:magazine/shared/global-widgets/dialog_custom.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';

class PopularPage extends StatefulWidget {
  PopularPage({super.key});

  final int query = Get.arguments;

  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> {
  final cMaga = Get.put(MagazineController());

  @override
  void initState() {
    cMaga.getMagazine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(
          onPressed: () {
            cMaga.getMagazine();
            Get.back();
          },
        ),
        title: Text(
          'Kumpulan Terpopuler ${widget.query}',
          style: fLg.copyWith(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
                onTap: () => DialogCustom.showConfirmationDialog('Konfirmasi',
                      'Gulir layar anda ke bawah, hingga muncul indikator loading 🔃',
                      () {},
                    ),
                child: Icon(CupertinoIcons.question_circle)),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await cMaga.getMagazine(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GetBuilder<MagazineController>(builder: (_) {
            if (_.loading) {
              return AlignedGridView.count(
                  padding: const EdgeInsets.only(top: 10, bottom: 0),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemCount: 4,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  itemBuilder: (BuildContext context, index) {
                    return const LoadingCardWidget();
                  });
            }

            if (_.listMagazine.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 50),
                child: BlankItem(
                  title: 'Majalah tidak tersedia',
                  img: 'assets/images/blank.png',
                ),
              );
            }

            List<MagazineItem> takeIt = _.listMagazine
                .where((magazine) => magazine.getYear() == widget.query)
                .toList();

            takeIt.sort((a, b) => b.likes!.compareTo(a.likes!));

            return AlignedGridView.count(
              padding: const EdgeInsets.only(top: 10, bottom: 0),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemCount: takeIt.length,
              shrinkWrap: true,
              crossAxisCount: 2,
              itemBuilder: (BuildContext context, index) {
                MagazineItem data = takeIt[index];
                return MagazineCard(
                  item: data,
                  image: "${Endpoint.storage}/${data.cover}",
                  title: data.name,
                  release: data.dateRelease,
                  view: data.likes,
                  pressRead: () {
                    Get.toNamed(AppRoutes.detailMagazine, arguments: data);
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
