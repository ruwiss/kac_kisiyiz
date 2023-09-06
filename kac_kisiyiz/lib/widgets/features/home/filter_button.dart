import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';

enum Filters { yeniler, katilimlar }

class FilterButton extends StatelessWidget {
  const FilterButton(
      {super.key,
      required this.filter,
      required this.currentFilter,
      this.onTap});

  final Function(Filters)? onTap;
  final Filters filter;
  final Filters currentFilter;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(filter);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 7, horizontal: currentFilter == filter ? 30.5 : 32),
        margin: const EdgeInsets.all(5),
        decoration: currentFilter == filter
            ? BoxDecoration(
                color: KColors.third.withOpacity(.35),
                border: Border.all(color: KColors.third, width: 1.5),
                borderRadius: BorderRadius.circular(kBorderRadius),
              )
            : null,
        child: Text(
          filter == Filters.yeniler ? "Yeniler" : "Katılımlar",
          style: TextStyle(
              fontWeight: currentFilter == filter ? FontWeight.w500 : null,
              fontSize: 15),
        ),
      ),
    );
  }
}
