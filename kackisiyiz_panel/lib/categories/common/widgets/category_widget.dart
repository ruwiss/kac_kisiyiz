import 'package:flutter/material.dart';
import 'package:kackisiyiz_panel/core/extensions/context_extensions.dart';
import 'package:kackisiyiz_panel/core/extensions/string_extensions.dart';
import 'package:kackisiyiz_panel/add_survey/common/models/category_model.dart';
import 'package:kackisiyiz_panel/core/widgets/textfield_input.dart';

class CategoryWidget extends StatefulWidget {
  final CategoryModel categoryModel;
  final Function(CategoryModel category)? onChanged;
  final Function(int id)? onDeleted;
  const CategoryWidget(
      {super.key, required this.categoryModel, this.onChanged, this.onDeleted});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool _showButton = false;
  bool _editMode = false;
  final _tName = TextEditingController();
  final _tIcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = widget.categoryModel.id == null;
    return InkWell(
      onTap: () {},
      onHover: (value) => setState(() => _showButton = value),
      mouseCursor: MouseCursor.defer,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: context.secondaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: !_editMode
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.categoryModel.name),
                      Icon(widget.categoryModel.iconData?.parseIconData()),
                    ],
                  )
                : Row(
                    children: [
                      TextFieldInput(hint: "İsim", controller: _tName),
                      TextFieldInput(hint: "iconData", controller: _tIcon),
                      TextButton(
                          onPressed: () {
                            if (widget.onChanged != null) {
                              var c = widget.categoryModel;
                              c.name = _tName.text;
                              c.iconData = _tIcon.text;
                              widget.onChanged!(c);
                            }
                            setState(() => _editMode = false);
                          },
                          child: const Text("Kaydet")),
                      if (widget.categoryModel.id != null)
                        TextButton(
                            onPressed: () {
                              if (widget.onChanged != null) {
                                widget.onDeleted!(widget.categoryModel.id!);
                              }
                            },
                            child: const Text("Sil")),
                      TextButton(
                          onPressed: () => setState(() => _editMode = false),
                          child: const Text("İptal"))
                    ],
                  ),
          ),
          if (_showButton && !_editMode || isEmpty && !_editMode)
            TextButton(
                onPressed: () => setState(() => _editMode = true),
                child: Text(isEmpty ? "Yeni Oluştur" : "Düzenle")),
        ],
      ),
    );
  }
}
