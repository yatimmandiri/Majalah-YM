import 'package:get/get.dart';
import 'package:magazine/common/services/app_request.dart';
import 'package:magazine/config/endpoints.dart';
import 'package:magazine/features/blog/model/blog_model.dart';
import 'package:magazine/features/blog/model/news_model.dart';

class BlogController extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;
  final _loadingSc = false.obs;
  bool get loadingSc => _loadingSc.value;
  var hasMoreNews = true.obs;
  var hasMoreBlog = true.obs;
  var pageNews = 1.obs;
  var pageBlog = 1.obs;

  List<BlogItem> listBlog = [];
  BlogItem? blogItem;
  List<NewsItem> listNews = [];
  NewsItem? newsItem;

  @override
  void onInit() {
    super.onInit();
    getBlog();
    getNews();
  }

  Future<void> getBlog({bool reset = true}) async {
    if (reset) {
      blogItem = null;
      listBlog = [];
    }

    _loading.value = true;

    String url = Endpoint.blog;

    final response = await AppRequest.getD(url);

    if (response != null && response is List) {
      for (var item in response) {
        if (item is Map<String, dynamic>) {
          var blogItem = BlogItem.fromJson(item);
          listBlog.add(blogItem);
        } else {
          print('Item in blog list is not a Map: $item');
        }
      }
    } else {
      print('Unexpected response format: $response');
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      _loading.value = false;
      update();
    });
  }

  Future<void> searchBlog({String key = '', bool reset = true}) async {
    int limit = 5;

    if (reset) {
      blogItem = null;
      listBlog = [];
    }

    if (_loadingSc.value) return;
    _loadingSc.value = true;

    String url =
        '${Endpoint.blog}?search=$key&per_page=${limit}&page=${pageBlog.value}';

    final response = await AppRequest.getD(url);

    try {
      if (response != null && response is List) {
        if (hasMoreBlog.isTrue) {
          pageBlog++;
          _loadingSc.value = false;

          for (var item in response) {
            if (item is Map<String, dynamic>) {
              var blogItem = BlogItem.fromJson(item);
              listBlog.add(blogItem);
            } else {
              print('Item in blog list is not a Map: $item');
            }
          }
        }
        print(response.length);
        if (response.length < limit) {
          hasMoreBlog.value = false;
        }
      } else {
        print('Unexpected response format: $response');
      }
    } catch (e) {
      print(e);
    } finally {
      _loadingSc.value = false;
    }
    update();
  }

  Future<void> getNews({bool reset = true}) async {
    if (reset) {
      newsItem = null;
      listNews = [];
    }

    _loading.value = true;

    String url = Endpoint.news;

    final response = await AppRequest.getD(url);

    if (response != null && response is List) {
      for (var item in response) {
        if (item is Map<String, dynamic>) {
          var newsItem = NewsItem.fromJson(item);
          listNews.add(newsItem);
        } else {
          print('Item in news list is not a Map: $item');
        }
      }
    } else {
      print('Unexpected response format: $response');
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      _loading.value = false;
      update();
    });
  }

  Future<void> searchNews({String key = '', bool reset = true}) async {
    int limit = 5;

    if (reset) {
      newsItem = null;
      listNews = [];
    }

    if (_loadingSc.value) return;
    _loadingSc.value = true;

    String url =
        '${Endpoint.news}?search=$key&per_page=${limit}&page=${pageNews.value}';

    final response = await AppRequest.getD(url);

    try {
      if (response != null && response is List) {
        if (hasMoreNews.isTrue) {
          pageNews++;
          _loadingSc.value = false;

          for (var item in response) {
            if (item is Map<String, dynamic>) {
              var newsItem = NewsItem.fromJson(item);
              listNews.add(newsItem);
            } else {
              print('Item in news list is not a Map: $item');
            }
          }
        }
        print(response.length);
        if (response.length < limit) {
          hasMoreNews.value = false;
        }
      } else {
        print('Unexpected response format: $response');
      }
    } catch (e) {
      print(e);
    } finally {
      _loadingSc.value = false;
    }
    update();
  }
}
