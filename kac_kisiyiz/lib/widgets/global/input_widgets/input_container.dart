import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';

class InputContainer extends StatefulWidget {
  const InputContainer({super.key, required this.child, this.focus = false});
  final Widget child;
  final bool focus;

  @override
  State<InputContainer> createState() => _InputContainerState();
}

class _InputContainerState extends State<InputContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: widget.focus ? KColors.primary : KColors.border,
              width: kBorderWidth),
          boxShadow: !widget.focus
              ? null
              : [
                  BoxShadow(
                    color: KColors.primary.withOpacity(.2),
                    blurRadius: 4,
                    offset: const Offset(3, 4), // Shadow position
                  ),
                ],
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: widget.child);
  }
}
