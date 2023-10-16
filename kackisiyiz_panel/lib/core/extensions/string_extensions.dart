import 'package:flutter/material.dart';

extension StringExtensions on String {
  IconData parseIconData() =>
      IconData(int.tryParse(this) ?? 0, fontFamily: 'MaterialIcons');
}
