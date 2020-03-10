import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SearchType { GROUP, WORKER }

Color getPriorityColor(String priority) {
  switch (priority) {
    case 'High':
      return Colors.red;
    case 'Medium':
      return Colors.orange;
    case 'Low':
      return Colors.yellow;
  }
  return Colors.grey;
}
