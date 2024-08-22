import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magazine/common/services/app_request.dart';
import 'package:magazine/common/utils/session.dart';
import 'package:magazine/config/endpoints.dart';
import 'package:magazine/core/error/exceptions.dart';
import 'package:magazine/features/auth/controller/auth_controller.dart';
import 'package:magazine/features/auth/data/model/user_model.dart';
import 'package:magazine/features/auth/data/service/auth_service.dart';
import 'package:magazine/features/blog/controller/blog_controller.dart';
import 'package:magazine/features/magazine/data/model/cat_magazine_model.dart';
import 'package:magazine/features/magazine/data/model/comment_model.dart';
import 'package:magazine/features/magazine/data/model/magazine_model.dart';
import 'package:magazine/features/magazine/data/service/comment_service.dart';
import 'package:magazine/features/magazine/data/service/magazine_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MagazineController extends GetxController {
  final cBlog = Get.put(BlogController());
  final cAuth = Get.put(AuthController());

  static const String _keyMagazine = 'key_magazine';
  TextEditingController controllerComment = TextEditingController();
  var isExpanded = false.obs;

  final _isOffline = false.obs;
  bool get isOffline => _isOffline.value;

  final _loading = false.obs;
  bool get loading => _loading.value;

  final _loadButton = false.obs;
  bool get loadButton => _loadButton.value;

  final _dataCacheMagazine = <MagazineItem>[].obs;
  List<MagazineItem> get dataCacheMagazine => _dataCacheMagazine;

  MagazineModel? magazineModel;
  List<MagazineItem> listMagazine = [];

  CatMagazineModel? catMagazineModel;
  List<CatMagazineItem> listCatMagazine = [];

  final RxMap<int, int> _lastPages = <int, int>{}.obs;
  final RxMap<int, int> _totalPages = <int, int>{}.obs;

  Map<int, int> get lastPages => _lastPages;
  Map<int, int> get totalPages => _totalPages;

  Iterable<String> nameValue = [];

  var users = <int, UserItem>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadMagazineFav();
    loadLastReadPages();
    // checkConnectivity();
  }

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  Future<void> fetchUser(int userId) async {
    String? token = await Session.getToken();

    if (!users.containsKey(userId)) {
      var user = await AuthService.fetchUser(token ?? '', userId);
      users[userId] = user!.data!;
    }
  }

  UserItem? getUserById(int userId) {
    return users[userId];
  }

  Future<void> checkConnectivity() async {
    List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      _isOffline.value = true;
      loadMagazineFav();
    } else {
      _isOffline.value = false;
      getMagazine();
    }

    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        _isOffline.value = true;
        loadMagazineFav();
      } else {
        _isOffline.value = false;
        getMagazine();
      }
    });
  }

  List<MagazineItem> get filteredMagazines => listMagazine.where((magazine) {
        int lastPage = _lastPages[magazine.id] ?? 0;
        int totalPage = _totalPages[magazine.id] ?? 0;
        return lastPage > 1 && lastPage < totalPage;
      }).toList();

  List<MagazineItem> getTopMagazinesByYear(int year, int count) {
    var magazinesByYear =
        listMagazine.where((magazine) => magazine.getYear() == year).toList();
    magazinesByYear.sort((a, b) => b.likes!.compareTo(a.likes!));
    return magazinesByYear.take(count).toList();
  }

  Future<void> loadLastReadPages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Assuming you have a list of magazine IDs
    for (var magazine in listMagazine) {
      int id = magazine.id ?? 0;
      _lastPages[id] = (prefs.getInt('${id}_lastPage') ?? 0);
      _totalPages[id] = (prefs.getInt('${id}_totalPage') ?? 0);
    }
  }

  Future<void> resetLastReadPages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var magazine in listMagazine) {
      int id = magazine.id ?? 0;
      await prefs.remove('${id}_lastPage');
      _lastPages[id] = 0;
    }
  }

  Future<void> removeUnneededPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var magazine in listMagazine) {
      int id = magazine.id ?? 0;
      int lastPage = _lastPages[id] ?? 0;
      int totalPage = _totalPages[id] ?? 0;

      if (lastPage >= totalPage || lastPage < 1) {
        await prefs.remove('${id}_lastPage');
        await prefs.remove('${id}_totalPage');
        _lastPages.remove(id);
        _totalPages.remove(id);
      }
    }
  }

  Future<void> clearAllPagesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var magazine in listMagazine) {
      int id = magazine.id!;
      await prefs.remove('${id}_lastPage');
      await prefs.remove('${id}_totalPage');
    }
    _lastPages.clear();
    _totalPages.clear();

    Fluttertoast.showToast(
        backgroundColor: Colors.green, msg: "Berhasil terhapus");

    update();
  }

  Future<void> _printSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    print("SharedPreferences Data:");
    for (String key in keys) {
      print('$key: ${prefs.get(key)}');
    }
  }

  Future<void> loadMagazineFav({bool reset = true}) async {
    if (reset) {
      magazineModel = null;
      _dataCacheMagazine.value = [];
    }
    _loading.value = true;
    // final prefs = await SharedPreferences.getInstance();
    // String? magazineJson = prefs.getString(_keyMagazine);

    // if (magazineJson != null) {
    //   List<dynamic> magazineMap = jsonDecode(magazineJson);
    //   _dataCacheMagazine.value =
    //       magazineMap.map((json) => MagazineItem.fromJson(json)).toList();
    //   update();
    // }

    try {
      MagazineModel? magazine = await MagazineService.fetchMagazine();

      if (magazine != null) {
        List<MagazineItem> data = magazine.data!;
        List<MagazineItem> resFav = data.where((m) {
          return m.favorites?.any((e) => e.id == cAuth.dataUser.id) ?? false;
        }).toList();

        _dataCacheMagazine.value = resFav;
      }
    } on NotFoundException catch (e) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: e.message,
      );
    } on ServerException catch (e) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: e.message,
      );
    } on Exception catch (e) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: 'An unexpected error occurred: $e',
      );
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      _loading.value = false;
      update();
    });
  }

  Future<bool> addOrRemoveMagazine(MagazineItem magazine) async {
    int index =
        dataCacheMagazine.indexWhere((existing) => existing.id == magazine.id);
    String? token = await Session.getToken();

    try {
      if (index == -1) {
        // listMagazineFav.add(magazine);
        // bool done = await saveMagazine();
        bool doneServer =
            await MagazineService.fetchFavMagazine(token!, magazine.id);
        if (doneServer) {
          Fluttertoast.showToast(
              backgroundColor: Colors.green, msg: "Majalah telah disimpan");
        } else {
          Fluttertoast.showToast(
              backgroundColor: Colors.red, msg: "Majalah gagal disimpan");
        }
      } else {
        // listMagazineFav.removeAt(index);
        // bool done = await saveMagazine();
        bool doneServer =
            await MagazineService.fetchFavMagazine(token!, magazine.id);
        if (doneServer) {
          Fluttertoast.showToast(
              backgroundColor: Colors.orange, msg: "Majalah telah dihapus");
        } else {
          Fluttertoast.showToast(
              backgroundColor: Colors.red, msg: "Majalah gagal dihapus");
        }
      }
      update();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveMagazine() async {
    final prefs = await SharedPreferences.getInstance();
    String magazineJson =
        jsonEncode(_dataCacheMagazine.map((e) => e.toJson()).toList());

    bool result = await prefs.setString(_keyMagazine, magazineJson);
    return result;
  }

  Future<void> getMagazine({bool reset = true}) async {
    if (reset) {
      magazineModel = null;
      listMagazine.clear();
    }

    _loading.value = true;

    try {
      String url = Endpoint.magazines;

      final response = await AppRequest.get(url);

      if (response != null && response is Map<String, dynamic>) {
        if (response['status'] == true) {
          magazineModel = MagazineModel.fromJson(response);

          if (magazineModel != null && magazineModel!.data != null) {
            listMagazine.addAll(magazineModel!.data!);
          }
          await loadLastReadPages();
          await removeUnneededPreferences();
          _printSharedPreferencesData();
        } else {
          print('Response status is not true: $response');
        }
      } else if (response != null && response is List) {
        // listMagazine.clear(); // Jika ingin mengosongkan daftar sebelum menambahkan item baru
        for (var item in response['data']) {
          var magazineItem = MagazineItem.fromJson(item);
          listMagazine.add(magazineItem);
        }
        await loadLastReadPages();
        await removeUnneededPreferences();
        _printSharedPreferencesData();
      } else {
        print('Unexpected response format: $response');
      }
    } on NotFoundException catch (e) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: e.message,
      );
    } on ServerException catch (e) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: e.message,
      );
    } on Exception catch (e) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: 'An unexpected error occurred: $e',
      );
    } 

    Future.delayed(const Duration(milliseconds: 500), () {
        _loading.value = false;
        update();
      });
  }

  Future<void> getCatMagazine({bool reset = true}) async {
    if (reset) {
      catMagazineModel = null;
      listCatMagazine = [];
    }

    String url = Endpoint.catMagazines;

    final response = await AppRequest.get(url);

    if (response != null && response is Map<String, dynamic>) {
      if (response['status'] == true) {
        catMagazineModel = CatMagazineModel.fromJson(response);

        if (catMagazineModel != null && catMagazineModel!.data != null) {
          listCatMagazine.addAll(catMagazineModel!.data!);
        }
      } else {
        print('Response status is not true: $response');
      }
    } else if (response != null && response is List) {
      for (var item in response['data']) {
        var catMagazineItem = CatMagazineItem.fromJson(item);
        listCatMagazine.add(catMagazineItem);
      }
    } else {
      print('Unexpected response format: $response');
    }

    update();
  }

  Future<void> getMagazineBy({bool reset = true, String query = ''}) async {
    if (reset) {
      magazineModel = null;
      listMagazine = [];
    }

    _loading.value = true;

    String url = '${Endpoint.magazines}?$query';

    final response = await AppRequest.get(url);

    if (response != null && response is Map<String, dynamic>) {
      if (response['status'] == true) {
        magazineModel = MagazineModel.fromJson(response);

        if (magazineModel != null && magazineModel!.data != null) {
          listMagazine.addAll(magazineModel!.data!);
        }
      } else {
        print('Response status is not true: $response');
      }
    } else if (response != null && response is List) {
      // listMagazine
      //     .clear(); // Jika ingin mengosongkan daftar sebelum menambahkan item baru
      for (var item in response['data']) {
        var magazineItem = MagazineItem.fromJson(item);
        listMagazine.add(magazineItem);
      }
    } else {
      print('Unexpected response format: $response');
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      _loading.value = false;
      update();
    });
  }

  Future<void> getMagazineByCat(
      {bool reset = true, List<int>? category}) async {
    if (reset) {
      magazineModel = null;
      listMagazine = [];
    }

    _loading.value = true;

    String query = category?.join(',') ?? '';

    String url = '${Endpoint.magazines}?categories=$query';

    final response = await AppRequest.get(url);

    if (response != null && response is Map<String, dynamic>) {
      if (response['status'] == true) {
        magazineModel = MagazineModel.fromJson(response);

        if (magazineModel != null && magazineModel!.data != null) {
          listMagazine.addAll(magazineModel!.data!);
        }
      } else {
        print('Response status is not true: $response');
      }
    } else if (response != null && response is List) {
      // listMagazine
      //     .clear(); // Jika ingin mengosongkan daftar sebelum menambahkan item baru
      for (var item in response['data']) {
        var magazineItem = MagazineItem.fromJson(item);
        listMagazine.add(magazineItem);
      }
    } else {
      print('Unexpected response format: $response');
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      _loading.value = false;
      update();
    });
  }

  // String? getCatName(String value, List<CatMagazineItem> listCatMagazines) {
  // final comment = comments.firstWhere((c) => c.id == commentId,
  //     orElse: () => CommentItem(id: 0, content: '', userId: 0));
  // final user = getUserById(comment.userId!);
  // return user?.name == cAuth.dataUser.name ? 'Anda' : user?.name;
  // if (cMaga.listCatMagazine.map((e) => e.id).join(',').contains(value)) {
  //   setState(() {
  //     // ignore: unused_local_variable
  //     nameVal = cMaga.listCatMagazine
  //         .where((e) => value.split(',').contains(e.id.toString()))
  //         .map((e) => e.name);
  //   });
  // } else {
  //   setState(() {
  //     nameVal = value.split(',');
  //   });
  // }
  // }

  MagazineItem? getMagazineById(int magazineId) {
    return listMagazine
        .firstWhereOrNull((magazine) => magazine.id == magazineId);
  }

  Future<bool> sendComment(int magazineId,
      {int parentId = 0, String content = ''}) async {
    String? token = await Session.getToken();

    _loadButton.value = true;

    try {
      bool doneServer = await CommentService.fetchComment(
          token!, magazineId, parentId, content);
      if (doneServer) {
        await getMagazine();
        Fluttertoast.showToast(
            backgroundColor: Colors.green, msg: "Komentar terkirim");
        _loadButton.value = false;
        update();
        return true;
      } else {
        Fluttertoast.showToast(
            backgroundColor: Colors.red, msg: "Komentar gagal terkirim");
        _loadButton.value = false;
        update();
        return false;
      }
    } catch (e) {
      _loadButton.value = false;
      return false;
    }
  }

  Future<bool> deleteComment(int magazineId, int commentId) async {
    String? token = await Session.getToken();

    _loadButton.value = true;

    try {
      bool doneServer =
          await CommentService.deleteComment(token!, magazineId, commentId);
      if (doneServer) {
        await getMagazine();
        Fluttertoast.showToast(
            backgroundColor: Colors.green, msg: "Komentar terhapus");
        _loadButton.value = false;
        update();
        return true;
      } else {
        Fluttertoast.showToast(
            backgroundColor: Colors.red, msg: "Komentar gagal terhapus");
        _loadButton.value = false;
        update();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  String? getAuthorName(int commentId, List<CommentItem> comments) {
    final comment = comments.firstWhere((c) => c.id == commentId,
        orElse: () => CommentItem(id: 0, content: '', userId: 0));
    final user = getUserById(comment.userId!);
    return user?.name == cAuth.dataUser.name ? 'Anda' : user?.name;
  }
}
