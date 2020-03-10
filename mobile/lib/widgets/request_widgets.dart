import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestWidgets {
  static Widget loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget error() {
    return Center(
      child: Text('Loading failed'),
    );
  }
}
