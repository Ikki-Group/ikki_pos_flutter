import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

abstract class AppToast {
  static void show(
    String text, {
    ToastificationType type = ToastificationType.success,
  }) {
    toastification.show(
      title: Text(text),
      style: ToastificationStyle.flatColored,
      type: type,
      autoCloseDuration: Duration(seconds: 3),
    );
  }

  static void dismiss() {
    toastification.dismissAll(delayForAnimation: true);
  }
}
