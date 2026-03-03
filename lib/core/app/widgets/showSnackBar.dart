// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowSnackBar {
  static void success(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static void error(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static void info(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
