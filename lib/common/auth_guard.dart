import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/features/auth/controller/auth_controller.dart';

class AuthGuard extends GetMiddleware {
//   Get the auth service
  final AuthController authService = Get.put(AuthController());

//   The default is 0 but you can update it to any number. Please ensure you match the priority based
//   on the number of guards you have.
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Navigate to login if client is not authenticated other wise continue
    if (!authService.isAuthenticated)
      return RouteSettings(name: AppRoutes.login);
    print(authService.isAuthenticated);
    return null;
  }
}
