import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kackisiyiz_panel/core/extensions/context_extensions.dart';
import 'package:kackisiyiz_panel/core/extensions/string_extensions.dart';
import 'package:kackisiyiz_panel/add_survey/common/models/add_survey_model.dart';
import 'package:kackisiyiz_panel/core/models/survey_model.dart';
import 'package:kackisiyiz_panel/add_survey/add_survey_view_model.dart';
import 'package:kackisiyiz_panel/core/app/base_view.dart';
import 'package:kackisiyiz_panel/core/widgets/textfield_input.dart';

class AddSurveyView extends StatefulWidget {
  final SurveyModel? surveyModel;
  const AddSurveyView({super.key, this.surveyModel});

  @override
  State<AddSurveyView> createState() => _AddSurveyViewState();
}

class _AddSurveyViewState extends State<AddSurveyView> {
  final _formKey = GlobalKey<FormState>();
  final _tTitle = TextEditingController();
  final _tContent = TextEditingController();
  final _tImage = TextEditingController();
  final _tAdLink = TextEditingController();
  final _tReward = TextEditingController();
  final _tUserId = TextEditingController();

  _clearFields() {
    _tTitle.clear();
    _tContent.clear();
    _tImage.clear();
    _tAdLink.clear();
    _tReward.clear();
    _tUserId.clear();
  }

  _getModel(AddSurveyViewModel addSurveyViewModel) {
    final model = widget.surveyModel;
    if (model != null) {
      _tTitle.text = model.title;
      _tContent.text = model.content;
      _tUserId.text = model.userId.toString();
      _tImage.text = model.imageUrl ?? "";
      _tAdLink.text = model.adLink ?? "";
      _tReward.text = model.isRewarded?.toString() ?? "";
      addSurveyViewModel.setSelectedCategory(model.categoryId);
    } else {
      addSurveyViewModel.getCategories();
      addSurveyViewModel.setSelectedCategory(null);
    }
  }

  void _publishSurvey(AddSurveyViewModel model) async {
    if (_formKey.currentState!.validate()) {
      final category = model.selectedCategory;
      if (category == null) return;
      final addSurveyModel = AddSurveyModel(id: widget.surveyModel?.id, categoryId: category.id!, title: _tTitle.text, content: _tContent.text, image: _tImage.text, adLink: _tAdLink.text, reward: _tReward.text, uid: _tUserId.text);
      if (await model.addSurvey(addSurveyModel)) {
        _clearFields();
        model.setSelectedCategory(null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AddSurveyViewModel>(
      onModelReady: (model) => _getModel(model),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text('Anket Ekle', style: context.titleStyle),
                  ),
                  Container(
                    color: Colors.white.withOpacity(.03),
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _dropdownButton(model),
                          const SizedBox(height: 20),
                          TextFieldInput(
                            hint: 'Başlık',
                            controller: _tTitle,
                            suffix: const Text(" ...Kaç Kişiyiz?"),
                          ),
                          TextFieldInput(
                            hint: 'İçerik',
                            controller: _tContent,
                            multiLine: true,
                          ),
                          TextFieldInput(hint: 'Resim', controller: _tImage),
                          const SizedBox(height: 25),
                          Flexible(
                            child: TextFieldInput(dontValidate: true, hint: 'Reklam URL', controller: _tAdLink),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: TextFieldInput(dontValidate: true, hint: 'UID', controller: _tUserId),
                              ),
                              Flexible(
                                child: TextFieldInput(dontValidate: true, hint: 'Ödül', controller: _tReward),
                              ),
                            ],
                          ),
                          if (model.infoText != null) Text(model.infoText!, textAlign: TextAlign.center),
                          const SizedBox(height: 20),
                          Platform.isAndroid
                              ? OutlinedButton(
                                  onPressed: () => _publishSurvey(model),
                                  child: const Text("Yayınla"),
                                )
                              : ElevatedButton(
                                  onPressed: () => _publishSurvey(model),
                                  child: const Text("Yayınla"),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropdownButton(AddSurveyViewModel model) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: DropdownButton<int>(
          value: model.selectedCategory?.id,
          isExpanded: true,
          underline: const SizedBox(),
          menuMaxHeight: 350,
          borderRadius: BorderRadius.circular(15),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          hint: Text(
            model.selectedCategory?.name ?? "Bir kategori seçiniz",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          items: model.categories?.map((category) {
            return DropdownMenuItem(
              value: category.id,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(category.name),
                  Icon(category.iconData?.parseIconData()),
                ],
              ),
            );
          }).toList(),
          onChanged: model.setSelectedCategory,
        ),
      );
}
