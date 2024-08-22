import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/config/endpoints.dart';
import 'package:magazine/features/magazine/controller/magazine_controller.dart';
import 'package:magazine/features/magazine/data/model/magazine_model.dart';
import 'package:magazine/features/magazine/view/widgets/magazine_card.dart';
import 'package:magazine/shared/global-widgets/blank_item.dart';
import 'package:magazine/shared/global-widgets/inputs.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';
import 'package:magazine/shared/global-widgets/navbar_bottom.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final cMaga = Get.put(MagazineController());

  @override
  void initState() {
    refresh();
    super.initState();
  }

  void refresh() {
    cMaga.getMagazine();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: RefreshIndicator(
          color: BaseColor.primary,
          onRefresh: () async {
            setState(() {
              refresh();
            });
          },
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: InputForm(
                  onTap: () => Get.toNamed(AppRoutes.search),
                  readOnly: true,
                  hintText: 'Ketik untuk menemukan majalah',
                  radius: 50,
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.search, size: 20),
                  ),
                  sideColor: Colors.transparent,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                height: size.height - 170,
                child: GetBuilder<MagazineController>(builder: (_) {
                  if (_.loading) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 15, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LoadingCustom(
                                radius: 5,
                              ),
                              LoadingCustom(
                                radius: 5,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 280,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return const LoadingCardWidget();
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  if (_.listMagazine.isEmpty) {
                    return const BlankItem();
                  }

                  _.listMagazine
                      .sort((a, b) => b.dateRelease!.compareTo(a.dateRelease!));

                  final magazineYears = _.listMagazine
                      .map((magazine) => magazine.getYear())
                      .toSet()
                      .toList();

                  return ListView.builder(
                    itemCount: magazineYears.length,
                    itemBuilder: (context, yearIndex) {
                      int year = magazineYears[yearIndex];
                      final filteredMagazines = _.listMagazine
                          .where((magazine) => magazine.getYear() == year)
                          .take(5)
                          .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  year.toString(),
                                  style: fprimMd,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.category,
                                        arguments: 'year=${year.toString()}');
                                  },
                                  child: Text(
                                    'Semuanya',
                                    style: fprimMd,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 280,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredMagazines.length,
                              itemBuilder: (BuildContext context, int index) {
                                MagazineItem data = filteredMagazines[index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child: MagazineCard(
                                    item: data,
                                    image: "${Endpoint.storage}/${data.cover}",
                                    title: data.name,
                                    release: data.dateRelease ?? '',
                                    view: data.likes,
                                    pressRead: () {
                                      Get.toNamed(AppRoutes.detailMagazine,
                                          arguments: data);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
              SizedBox(
                height: 170,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CBottomNav(
        selectedItem: 1,
      ),
    );
  }
}
