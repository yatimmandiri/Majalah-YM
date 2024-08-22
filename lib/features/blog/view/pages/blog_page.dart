import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/features/blog/controller/blog_controller.dart';
import 'package:magazine/features/blog/model/blog_model.dart';
import 'package:magazine/features/blog/model/news_model.dart';
import 'package:magazine/features/blog/view/widgets/blog_card.dart';
import 'package:magazine/features/blog/view/widgets/news_card.dart';
import 'package:magazine/shared/global-widgets/blank_item.dart';
import 'package:magazine/shared/global-widgets/inputs.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';
import 'package:magazine/shared/global-widgets/navbar_bottom.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final cBlog = Get.put(BlogController());

    void refresh() {
      cBlog.getBlog();
      cBlog.getNews();
    }

    return Scaffold(
      body: RefreshIndicator.adaptive(
        color: BaseColor.primary,
        onRefresh: () async => refresh(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InputForm(
                  onTap: () {
                    Get.toNamed(AppRoutes.searchBlog);
                  },
                  readOnly: true,
                  hintText: 'Ketik untuk menemukan berita/blog',
                  radius: 50,
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.search, size: 20),
                  ),
                  sideColor: Colors.transparent,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Berita Terkini',
                      style: fprimMd,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                            '${AppRoutes.detailBlog}?url=https://yatimmandiri.org/news/');
                      },
                      child: Text(
                        'Semuanya',
                        style: fprimMd,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: size.height * .3,
                child: GetBuilder<BlogController>(builder: (_) {
                  if (_.loading) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return const LoadingCardWidget();
                      },
                    );
                  }
                  if (_.listNews.isEmpty) {
                    return const BlankItem();
                  }

                  List<NewsItem> takeIt = _.listNews.take(5).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 0),
                    itemCount: takeIt.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      NewsItem data = takeIt[index];
                      return NewsCard(
                        img: data.large,
                        title: data.title,
                        release: data.date,
                        width: size.width * .8,
                        height: size.height * .8,
                        onTap: () {
                          Get.toNamed(
                              '${AppRoutes.detailBlog}?url=${data.link}');
                        },
                      );
                    },
                  );
                }),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Blog',
                          style: fprimMd,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                                '${AppRoutes.detailBlog}?url=https://yatimmandiri.org/blog/');
                          },
                          child: Text(
                            'Semuanya',
                            style: fprimMd,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height,
                      child: GetBuilder<BlogController>(builder: (_) {
                        if (_.loading) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return const LoadingCardWidget();
                            },
                          );
                        }

                        if (_.listBlog.isEmpty) {
                          return const BlankItem();
                        }
                        return ListView.builder(
                          itemCount: _.listBlog.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, index) {
                            BlogItem data = _.listBlog[index];
                            return BlogCard(
                              image: data.thumbnail,
                              title: data.title,
                              release: data.date,
                              pressRead: () {
                                Get.toNamed(
                                    '${AppRoutes.detailBlog}?url=${data.link}');
                              },
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CBottomNav(
        selectedItem: 2,
      ),
    );
  }
}
