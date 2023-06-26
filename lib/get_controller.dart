import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Color color = Colors.white;

class price extends GetxController {
  RxString bitPrice = "0".obs;
  RxString ethPrice = "0".obs;

  void bitChange(String s) {
    color = double.parse(s) < double.parse(bitPrice.value)
        ? Colors.red
        : Colors.green;
    bitPrice.value = s;
  }

  void ethChange(String s) {
    ethPrice.value = s;
  }
}
