// File: navigation_controller.dart
// Deskripsi: GetX Controller untuk mengelola bottom navigation state.

import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
