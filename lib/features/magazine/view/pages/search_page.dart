import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/utils/app_format.dart';
import 'package:magazine/config/endpoints.dart';
import 'package:magazine/features/magazine/controller/magazine_controller.dart';
import 'package:magazine/features/magazine/data/model/cat_magazine_model.dart';
import 'package:magazine/features/magazine/data/model/magazine_model.dart';
import 'package:magazine/features/magazine/view/widgets/cat_item.dart';
import 'package:magazine/features/magazine/view/widgets/magazine_card.dart';
import 'package:magazine/shared/global-widgets/blank_item.dart';
import 'package:magazine/shared/global-widgets/inputs.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final cMaga = Get.put(MagazineController());
  final FocusNode focusNode = FocusNode();

  String searchKeyword = '';
  List<int> categories = [];

  @override
  void initState() {
    super.initState();
    cMaga.getCatMagazine();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 10),
              child: Row(
                children: [
                  BackButton(
                    onPressed: () {
                      cMaga.getMagazineByCat();
                      Get.back();
                    },
                  ),
                  Expanded(
                    child: InputForm(
                      onChange: (key) {
                        setState(() {
                          searchKeyword = key;
                        });
                      },
                      hintText: 'Ketik untuk menemukan majalah',
                      radius: 50,
                      focusNode: focusNode,
                      suffixIcon: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.search, size: 20),
                      ),
                      sideColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 40,
                child: GetBuilder<MagazineController>(builder: (_) {
                  if (_.listCatMagazine.isEmpty) {
                    return const LoadingCatWidget();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(),
                      itemCount: _.listCatMagazine.length,
                      itemBuilder: (context, index) {
                        CatMagazineItem data = _.listCatMagazine[index];
                        return CatItem(
                          id: data.id,
                          title: data.name,
                          categories: categories,
                          onToggle: (id) {
                            if (categories.contains(id)) {
                              categories.remove(id);
                            } else {
                              categories.add(id);
                            }
                            cMaga.getMagazineByCat(category: categories);
                          },
                        );
                      },
                    ),
                  );
                })),
            const SizedBox(
              height: 20,
            ),
            Padding(
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

                List<MagazineItem> result = _.listMagazine
                    .where((magazine) =>
                        magazine.name!
                            .toLowerCase()
                            .contains(searchKeyword.toLowerCase()) ||
                        magazine.description!
                            .toLowerCase()
                            .contains(searchKeyword.toLowerCase()) ||
                        AppFormat.date2(magazine.dateRelease!)
                            .toLowerCase()
                            .contains(searchKeyword.toLowerCase()))
                    .toList();

                if (result.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: BlankItem(
                      title: 'Majalah tidak ditemukan',
                      img: 'assets/images/search.png',
                    ),
                  );
                }

                return AlignedGridView.count(
                  padding: const EdgeInsets.only(top: 10, bottom: 0),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemCount: result.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  itemBuilder: (BuildContext context, index) {
                    MagazineItem data = result[index];
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
          ],
        ),
      ),
    );
  }
}
