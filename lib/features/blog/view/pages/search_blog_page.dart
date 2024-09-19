import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/features/blog/controller/blog_controller.dart';
import 'package:magazine/features/blog/model/blog_model.dart';
import 'package:magazine/features/blog/model/news_model.dart';
import 'package:magazine/features/blog/view/widgets/blog_card.dart';
import 'package:magazine/shared/global-widgets/blank_item.dart';
import 'package:magazine/shared/global-widgets/dialog_custom.dart';
import 'package:magazine/shared/global-widgets/inputs.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';

class SearchBlogPage extends StatefulWidget {
  const SearchBlogPage({super.key});

  @override
  State<SearchBlogPage> createState() => _SearchBlogPageState();
}

class _SearchBlogPageState extends State<SearchBlogPage> {
  final cBlog = Get.put(BlogController());
  final FocusNode focusNode = FocusNode();
  final searchNewsC = TextEditingController();
  final searchBlogC = TextEditingController();

  final ScrollController scrollNewsC = ScrollController();
  final ScrollController scrollBlogC = ScrollController();

  @override
  void initState() {
    cBlog.searchBlog(reset: true, key: searchBlogC.text);
    cBlog.searchNews(reset: false, key: searchNewsC.text);
    scrollNewsC.addListener(() {
      if (scrollNewsC.position.maxScrollExtent == scrollNewsC.offset) {
        cBlog.searchNews(reset: false, key: searchNewsC.text);
      }
    });

    scrollBlogC.addListener(() {
      if (scrollBlogC.position.maxScrollExtent == scrollBlogC.offset) {
        cBlog.searchBlog(reset: false, key: searchBlogC.text);
      }
    });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void dispose() {
    scrollNewsC.dispose();
    scrollBlogC.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 10),
                child: Row(
                  children: [
                    BackButton(
                      onPressed: () async {
                        Get.back();
                        await cBlog.getBlog();
                        await cBlog.getNews();
                        searchBlogC.clear();
                        searchNewsC.clear();
                        cBlog.pageBlog.value = 1;
                        cBlog.pageNews.value = 1;
                        cBlog.hasMoreBlog.value = true;
                        cBlog.hasMoreNews.value = true;
                      },
                    ),
                    Text(
                      'Pencarian',
                      style: fsecLg,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: GestureDetector(
                          onTap: () => DialogCustom.showConfirmationDialog(
                              'Tindakan',
                              'Untuk mencari literasi, ketik saja pada kolom pencarian, setelah itu tekan tombol ikon cari',
                              () {},
                              true),
                          child: const Icon(
                            CupertinoIcons.question_circle,
                            color: BaseColor.secondary,
                          )),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 35,
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 3,
                  indicatorColor: BaseColor.secondary,
                  dividerColor: BaseColor.secondary.withOpacity(0.5),
                  labelColor: BaseColor.secondary,
                  unselectedLabelColor: BaseColor.secondary.withOpacity(0.5),
                  labelPadding: const EdgeInsets.only(bottom: 14),
                  labelStyle: fMd,
                  unselectedLabelStyle: fMd,
                  tabs: [
                    Tab(
                        icon: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: const Text('Berita Terkini'))),
                    Tab(
                        icon: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: const Text('Blog'))),
                  ],
                ),
              ),
              SizedBox(
                width: size.width,
                height: size.height,
                child: TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 60,
                            child: InputForm(
                              controller: searchNewsC,
                              hintText: 'Ketik untuk menemukan berita',
                              radius: 50,
                              focusNode: focusNode,
                              suffixIcon: InkWell(
                                onTap: () {
                                  cBlog.pageNews.value = 1;
                                  cBlog.hasMoreNews.value = true;
                                  cBlog.searchNews(key: searchNewsC.text);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.search, size: 20),
                                ),
                              ),
                              sideColor: Colors.transparent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GetBuilder<BlogController>(builder: (_) {
                            if (_.listNews.isEmpty) {
                              return const BlankItem();
                            }

                            if (_.loading) {
                              return SizedBox(
                                height: Get.height * .5,
                                child: ListView.builder(
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: LoadingCustom(
                                        height: 80,
                                        width: double.infinity,
                                        radius: 20,
                                      ),
                                    );
                                  },
                                ),
                              );
                            }

                            return SizedBox(
                              height: size.height * .8,
                              child: ListView.builder(
                                controller: scrollNewsC,
                                itemCount: _.listNews.length + 1,
                                padding: const EdgeInsets.only(bottom: 35),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (index < _.listNews.length) {
                                    NewsItem data = _.listNews[index];

                                    return BlogCard(
                                      image: data.thumbnail,
                                      title: data.title,
                                      release: data.date,
                                      pressRead: () {
                                        Get.toNamed(
                                            '${AppRoutes.detailBlog}?url=${data.link}');
                                      },
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Center(
                                        child: _.hasMoreNews.isTrue
                                            ? const Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 120),
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : const Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 150),
                                                child: Text(
                                                    'sudah tidak ada topik lagi'),
                                              ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    // Blog 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 60,
                            child: InputForm(
                              controller: searchBlogC,
                              hintText: 'Ketik untuk menemukan blog',
                              radius: 50,
                              focusNode: focusNode,
                              suffixIcon: InkWell(
                                onTap: () {
                                  cBlog.pageBlog.value = 1;
                                  cBlog.hasMoreBlog.value = true;
                                  cBlog.searchBlog(key: searchBlogC.text);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.search, size: 20),
                                ),
                              ),
                              sideColor: Colors.transparent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: size.height * .7,
                            child: GetBuilder<BlogController>(builder: (_) {
                              if (_.listBlog.isEmpty) {
                                return const BlankItem();
                              }

                              if (_.loading) {
                                return SizedBox(
                                  height: Get.height * .5,
                                  child: ListView.builder(
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: LoadingCustom(
                                          height: 80,
                                          width: double.infinity,
                                          radius: 20,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }

                              return ListView.builder(
                                controller: scrollBlogC,
                                itemCount: _.listBlog.length + 1,
                                padding: const EdgeInsets.only(bottom: 35),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (index < _.listBlog.length) {
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
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Center(
                                          child: _.hasMoreBlog.isTrue
                                              ? const CircularProgressIndicator()
                                              : const Text(
                                                  'sudah tidak ada topik lagi')),
                                    );
                                  }
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
            ],
          ),
        ),
      ),
    );
  }
}
