import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/images.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key, this.height, this.width});
  const TitleWidget.big({super.key, this.width}) : height = 60;
  const TitleWidget.medium({super.key, this.width}) : height = 50;

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      KImages.logoText,
      height: height,
      width: width,
    );
  }
}
