import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:magazine/features/auth/pages/login_page.dart';
import 'package:magazine/features/auth/pages/profile_page.dart';
import 'package:magazine/features/auth/pages/verify_phone_page.dart';
import 'package:magazine/features/blog/view/pages/blog_page.dart';
import 'package:magazine/features/blog/view/pages/search_blog_page.dart';
import 'package:magazine/features/blog/view/widgets/detail_page.dart';
import 'package:magazine/features/home_page.dart';
import 'package:magazine/features/magazine/data/model/magazine_model.dart';
import 'package:magazine/features/magazine/view/pages/category_page.dart';
import 'package:magazine/features/magazine/view/pages/detail/comment_page.dart';
import 'package:magazine/features/magazine/view/pages/detail/detail_page.dart';
import 'package:magazine/features/magazine/view/pages/fav_page.dart';
import 'package:magazine/features/magazine/view/pages/group_page.dart';
import 'package:magazine/features/magazine/view/pages/search_page.dart';
import 'package:magazine/features/magazine/view/widgets/popular_page.dart';
import 'package:magazine/features/notification/notif_page.dart';
import 'package:magazine/features/setting_page.dart';
import 'package:magazine/features/splash_screen.dart';
import 'package:magazine/common/auth_guard.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const group = '/group';
  static const notif = '/notification';
  static const search = '/search';

  static const detailMagazine = '/detail-magazine';
  static const favMagazine = '/fav-magazine';
  static const category = '/cat-magazine';
  static const popular = '/popular-magazine';
  static const comment = '/comment';

  // Auth
  static const login = '/auth-login';
  static const verify = '/verify';
  static const profile = '/profile';
  static const setting = '/setting';

  // Blog Area
  static const blog = '/blog';
  static const detailBlog = '/detail-blog';
  static const searchBlog = '/search-blog';

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
    ),

    // Auth Area
    GetPage(
        name: login,
        page: () => LoginPage(),
        transition: Transition.downToUp,
        transitionDuration: Duration(milliseconds: 500)),
    GetPage(
      name: verify,
      page: () {
        {
          final arguments = Get.arguments;
          GoogleSignInAccount? googleSignInAccount;
          if (arguments != null && arguments is GoogleSignInAccount) {
            googleSignInAccount = arguments;
          }
          return VerifyPhonePage(user: googleSignInAccount);
        }
      },
    ),
    GetPage(
      name: profile,
      page: () => ProfilePage(),
    ),
    GetPage(
      name: setting,
      page: () => SettingPage(),
    ),

    // Dashboard Area
    GetPage(
      name: home,
      page: () => HomePage(),
    ),
    GetPage(
      name: notif,
      page: () => const NotifPage(),
      middlewares: [AuthGuard()],
    ),

    // Magazine Area
    GetPage(
      name: group,
      page: () => const GroupPage(),
    ),
    GetPage(
      name: search,
      page: () => const SearchPage(),
    ),
    GetPage(
      name: detailMagazine,
      page: () {
        final arguments = Get.arguments;
        MagazineItem? magazineItem;
        if (arguments != null && arguments is MagazineItem) {
          magazineItem = arguments;
        }
        return DetailPage(item: magazineItem!);
      },
    ),
    GetPage(
      name: favMagazine,
      page: () => FavoritePage(),
    ),
    GetPage(
      name: category,
      page: () => CategoryPage(),
    ),
    GetPage(
      name: popular,
      page: () => PopularPage(),
    ),
    GetPage(
      name: comment,
      page: () => CommentPage(),
      middlewares: [AuthGuard()],
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 500),
    ),

    // Blog Area
    GetPage(
      name: blog,
      page: () => BlogPage(),
    ),
    GetPage(
      name: detailBlog,
      page: () {
        {
          final String? url = Get.parameters['url'];
          return DetailBlogPage(url: url);
        }
      },
    ),
    GetPage(
      name: searchBlog,
      page: () => SearchBlogPage(),
    ),
  ];

  static MaterialPageRoute get pageNotFound => MaterialPageRoute(
        builder: (context) => Scaffold(
            body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/no-results.png',
                height: 200,
                width: 200,
              ),
              const Text(
                'Page Not Found',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 50,
              ),
              BackButton(
                onPressed: () {
                  Get.offAll(AppRoutes.home);
                },
                color: Colors.orange,
              )
            ],
          ),
        )),
      );
}
