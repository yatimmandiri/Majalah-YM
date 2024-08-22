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
import 'package:animated_text_kit/animated_text_kit.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({super.key});

  final String query = Get.arguments;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final cMaga = Get.put(MagazineController());

  @override
  void initState() {
    refresh();
    super.initState();
  }

  void refresh() async {
    await cMaga.getMagazineBy(query: widget.query);
    await cMaga.getCatMagazine();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String value = widget.query.split('=')[1];

    if (value.split(',').every((id) =>
        cMaga.listCatMagazine.map((e) => e.id).join(',').contains(id))) {
      setState(() {
        cMaga.nameValue = cMaga.listCatMagazine
            .where((e) => value.split(',').contains(e.id.toString()))
            .map((e) => e.name!);
      });
    } else {
      setState(() {
        cMaga.nameValue = value.split(',');
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(
          onPressed: () {
            cMaga.getMagazine();
            Get.back();
          },
        ),
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText('Kumpulan  ${cMaga.nameValue.toSet().join(', ')}',
                textStyle: fLg.copyWith(fontSize: 18, color: Colors.white),
                speed: Duration(milliseconds: 100),
                textAlign: TextAlign.center),
          ],
          isRepeatingAnimation: true,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
                onTap: () => DialogCustom.showConfirmationDialog(
                      'Informasi',
                      'Gulir layar anda ke bawah, hingga muncul indikator loading 🔃',
                      () {},
                    ),
                child: Icon(CupertinoIcons.question_circle)),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => refresh(),
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

            return AlignedGridView.count(
              padding: const EdgeInsets.only(top: 10, bottom: 0),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemCount: _.listMagazine.length,
              shrinkWrap: true,
              crossAxisCount: 2,
              itemBuilder: (BuildContext context, index) {
                MagazineItem data = _.listMagazine[index];
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
