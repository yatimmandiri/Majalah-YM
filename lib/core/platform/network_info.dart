import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkInfo {
  static Future<bool> isConnected() async {
    final connectivityRes = await Connectivity().checkConnectivity();
    return connectivityRes == ConnectivityResult.none;
  }
}

class ConnectivityService extends GetxService {
  var isConnected = true.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // Listen to connectivity changes and update isConnected accordingly
  //   Connectivity()
  //       .onConnectivityChanged
  //       .listen((List<ConnectivityResult> result) {
  //     isConnected.value = result != ConnectivityResult.none;
  //   });
  // }
}
