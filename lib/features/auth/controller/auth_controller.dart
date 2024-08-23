import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/services/app_request.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/common/utils/session.dart';
import 'package:magazine/config/endpoints.dart';
import 'package:magazine/features/auth/data/model/user_model.dart';
import 'package:magazine/features/auth/data/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  TextEditingController nomorC = TextEditingController();

  final _dataUser = UserItem().obs;
  UserItem get dataUser => _dataUser.value;

  final _tokenAccess = ''.obs;
  String get tokenAccess => _tokenAccess.value;

  final _loading = false.obs;
  bool get loading => _loading.value;

  // Method untuk memeriksa apakah pengguna sudah login
  bool get isAuthenticated => _tokenAccess.value.isNotEmpty;

  var userModel = Rxn<UserModel>();

  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    getToken();
    profile();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      _tokenAccess.value = token;
    } else {
      _tokenAccess.value = '';
    }

    update();
  }

  // Method untuk login dengan Google
  Future<GoogleSignInAccount?> login() async {
    await getout();

    try {
      final user = await _googleSignIn.signIn();

      if (user == null) {
        Get.back();
      } else {
        print(user.id);
        print(user.photoUrl);
        Session.saveGooglePhoto(user.photoUrl);
        await cbLogin(user.id, user.email, user.displayName);
      }
    } catch (e) {
      Get.back();
      Fluttertoast.showToast(backgroundColor: Colors.red, msg: "Gagal Masuk");
    }
    return null;
  }

  Future<void> cbLogin(String googleId, email, name) async {
    String url = Endpoint.cbGoogleId;

    _loading.value = true;

    try {
      final response = await AppRequest.post(url, {
        'google_id': googleId,
        'email': email,
        'name': name,
      });

      if (response['status'] == true) {
        print(response['data']['access_token']);
        Session.saveToken(response['data']['access_token']);
        // nomorC.clear();
        getToken();

        Timer(const Duration(seconds: 2), () {
          profile();
          _loading.value = false;
          Fluttertoast.showToast(
              backgroundColor: Colors.green, msg: "Berhasil login");
          Get.offAllNamed(AppRoutes.home);
        });
      } else {
        Fluttertoast.showToast(backgroundColor: Colors.red, msg: "Gagal login");
        Timer(const Duration(seconds: 2), () {
          _loading.value = false;
        });
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
      throw Exception('Failed to sign in with Google');
    }

    update();
  }

  Future<void> profile() async {
    String? token = await Session.getToken();

    if (token != null) {
      UserModel? user = await _authService.fetchUserProfile(token);

      if (user != null) {
        _dataUser.value = user.data ?? UserItem();
      } else {
        // Handle error loading profile
        Fluttertoast.showToast(
            backgroundColor: Colors.red, msg: "Failed to load profile");
      }
    } else {
      // Handle missing token
      print('User not logged in');
    }

    update();
  }

  Future<void> logout() async {
    String url = Endpoint.logout;
    String? token = await Session.getToken();

    _loading.value = true;

    try {
      final response = await AppRequest.post(url, {}, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response['status'] == true) {
        await _googleSignIn.disconnect();
        _tokenAccess.value = '';
        _dataUser.value = UserItem();
        await Session.clearToken();
        await Session.clearGooglePhoto();

        Timer(const Duration(seconds: 2), () {
          _loading.value = false;
          Fluttertoast.showToast(
              backgroundColor: Colors.green, msg: "Berhasil logout");
          Get.offAllNamed(AppRoutes.home);
        });
      } else {
        _loading.value = false;
        Fluttertoast.showToast(
            backgroundColor: Colors.red, msg: "Gagal logout");
      }
    } catch (e) {
      print("Error during Google Sign-Out: $e");
    }

    update();
  }

  void cancelGoogleSignIn() {
    // Membatalkan login Google jika sedang berlangsung
    _googleSignIn.disconnect();
  }

  bool isValidWhatsAppNumber(String number) {
    // Menghapus spasi dan karakter non-digit
    String cleanedNumber = number.replaceAll(RegExp(r'\D'), '');

    // Memeriksa panjang nomor setelah pembersihan
    if (cleanedNumber.length < 10) {
      return false;
    }

    // Memeriksa awalan nomor
    if (!cleanedNumber.startsWith('08') && !cleanedNumber.startsWith('+62')) {
      return false;
    }

    return true;
  }

  Future<void> getout() async {
    _tokenAccess.value = '';
    _dataUser.value = UserItem();
    await Session.clearToken();
    _loading.value = false;
    await Session.clearGooglePhoto();
    Fluttertoast.showToast(backgroundColor: BaseColor.orange, msg: "Proses...");
    // await _googleSignIn.disconnect();
  }
}
