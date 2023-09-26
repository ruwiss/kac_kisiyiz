import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/images.dart';

class BackdropFilterAuth extends StatelessWidget {
  const BackdropFilterAuth({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 34),
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            opacity: .5,
            image: AssetImage(
              KImages.authBackground,
            ),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          child: child,
        ),
      ),
    );
  }
}
