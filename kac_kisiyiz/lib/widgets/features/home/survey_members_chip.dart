import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';

class SurveyMembersChip extends StatelessWidget {
  const SurveyMembersChip({super.key, required this.num, this.positive = true});
  final int num;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
      decoration: BoxDecoration(
        color: positive
            ? KColors.disabled.withOpacity(.1)
            : Colors.redAccent.withOpacity(.15),
        border: Border.all(color: KColors.border),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          positive
              ? const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 25,
                )
              : Icon(
                  Icons.close,
                  color: Colors.redAccent.withOpacity(.7),
                  size: 25,
                ),
          Text(
            " $num ",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: KColors.primary),
          ),
          Text(
            "Kişi",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: KColors.primary.withOpacity(.85)),
          )
        ],
      ),
    );
  }
}
