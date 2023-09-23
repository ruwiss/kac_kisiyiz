import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/services/models/categories_model.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';
import 'package:kac_kisiyiz/widgets/global/input_widgets/input_container.dart';

class InputCategory extends StatefulWidget {
  const InputCategory(
      {super.key,
      required this.items,
      required this.onSelected,
      this.text,
      this.value});
  final List<CategoryModel> items;
  final Function(int?) onSelected;
  final String? text;
  final int? value;

  @override
  State<InputCategory> createState() => _InputCategoryState();
}

class _InputCategoryState extends State<InputCategory> {
  int? _dropdownvalue;

  @override
  void initState() {
    _dropdownvalue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: DropdownButton(
        value: _dropdownvalue,
        isExpanded: true,
        iconEnabledColor: KColors.disabled,
        underline: const SizedBox(),
        menuMaxHeight: 350,
        borderRadius: BorderRadius.circular(15),
        hint: Text(
          widget.text ?? "Bir kategori seçiniz",
          style: TextStyle(
            fontSize: kFontSizeButton,
            fontWeight: FontWeight.w500,
            color: KColors.disabled,
          ),
        ),
        items: widget.items.map((item) {
          return DropdownMenuItem(
            value: item.id,
            child: Text(
              item.category,
              style: const TextStyle(color: Colors.black87),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() => _dropdownvalue = newValue);
          widget.onSelected(newValue);
        },
      ),
    );
  }
}
