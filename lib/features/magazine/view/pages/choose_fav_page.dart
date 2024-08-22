import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/features/magazine/controller/magazine_controller.dart';
import 'package:magazine/features/magazine/data/model/cat_magazine_model.dart';
import 'package:magazine/features/magazine/view/widgets/cat_item.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';

class ChooseFavPage extends StatefulWidget {
  ChooseFavPage({super.key});

  @override
  State<ChooseFavPage> createState() => _ChooseFavPageState();
}

class _ChooseFavPageState extends State<ChooseFavPage> {
  final cMaga = Get.put(MagazineController());

  List<int> categories = [];

  @override
  void initState() {
    super.initState();
    cMaga.getCatMagazine();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Column(
                  children: [
                    Text('Favorit majalah anda?', style: fBlackLg),
                    const SizedBox(
                      height: 8,
                    ),
                    Text('Pilih lebih dari satu.', style: fBlackLg),
                  ],
                ),
              ),
              GetBuilder<MagazineController>(builder: (_) {
                if (_.listCatMagazine.isEmpty) {
                  return SizedBox(height: 40, child: const LoadingCatWidget());
                }

                return SizedBox(
                  height: size.height * .5,
                  width: size.width,
                  child: AlignedGridView.count(
                    padding: const EdgeInsets.only(top: 10, bottom: 0),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                    itemCount: _.listCatMagazine.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    itemBuilder: (BuildContext context, index) {
                      CatMagazineItem data = _.listCatMagazine[index];
                      return CatItem(
                        id: data.id,
                        marginR: 0,
                        title: data.name,
                        categories: categories,
                        onToggle: (id) {
                          // if (categories.contains(id)) {
                          //   categories.remove(id);
                          // } else {
                          //   categories.add(id);
                          // }
                          // cMaga.getMagazineByCat(category: categories);
                        },
                      );
                    },
                  ),
                );
              }),
              IconButton(
                  onPressed: () {
                    Get.offNamed(AppRoutes.home);
                  },
                  icon: Icon(
                    Icons.arrow_circle_right_outlined,
                    size: 60,
                    color: BaseColor.primary,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
