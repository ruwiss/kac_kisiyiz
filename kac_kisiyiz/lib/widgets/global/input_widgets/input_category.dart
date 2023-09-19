import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';
import 'package:kac_kisiyiz/widgets/global/input_widgets/input_container.dart';

class InputCategory extends StatefulWidget {
  const InputCategory(
      {super.key, required this.items, required this.onSelected});
  final List<String> items;
  final Function(String) onSelected;

  @override
  State<InputCategory> createState() => _InputCategoryState();
}

class _InputCategoryState extends State<InputCategory> {
  String _dropdownvalue = "";

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: DropdownButton(
        value: _dropdownvalue.isEmpty ? null : _dropdownvalue,
        isExpanded: true,
        iconEnabledColor: KColors.disabled,
        underline: const SizedBox(),
        menuMaxHeight: 350,
        borderRadius: BorderRadius.circular(15),
        hint: Text(
          "Bir kategori seçiniz",
          style: TextStyle(
            fontSize: kFontSizeButton,
            fontWeight: FontWeight.w500,
            color: KColors.disabled,
          ),
        ),
        items: widget.items.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(
              items,
              style: const TextStyle(color: Colors.black87),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() => _dropdownvalue = newValue!);
          widget.onSelected(newValue ?? "");
        },
      ),
    );
  }
}
