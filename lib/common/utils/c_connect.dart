import 'package:get/get.dart';
import 'package:magazine/core/platform/network_info.dart';

class ConnectivityController extends GetxController {
  // Inject the ConnectivityService
  final ConnectivityService connectivityService = Get.put(ConnectivityService());

  @override
  void onInit() {
    super.onInit();
    // Listen to connectivity changes
    connectivityService.isConnected.listen((isConnected) {
      if (!isConnected) {
        Get.snackbar(
          "No Internet",
          "You are not connected to the internet",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(days: 365), // Keep showing until connection is restored
        );
      } else {
        Get.closeAllSnackbars();
      }
    });
  }
}
