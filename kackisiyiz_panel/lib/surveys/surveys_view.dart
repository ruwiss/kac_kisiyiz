import 'package:flutter/material.dart';
import 'package:kackisiyiz_panel/core/models/survey_model.dart';
import 'package:kackisiyiz_panel/surveys/surveys_view_model.dart';
import 'package:kackisiyiz_panel/core/app/base_view.dart';
import 'package:kackisiyiz_panel/surveys/common/widgets/survey_widget.dart';
import 'package:kackisiyiz_panel/core/widgets/textfield_input.dart';
import '../core/app/base_view_model.dart';

class SurveysView extends StatelessWidget {
  SurveysView({super.key});

  final _tSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<SurveysViewModel>(
      onModelReady: (model) => model.getSurveys(),
      builder: (context, model, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: model.state == ViewState.busy
              ? const Text("Bekleyiniz..")
              : model.surveys == null
                  ? const Text("Bir sorun oluştu")
                  : Column(
                      children: [
                        TextFieldInput(
                          hint: "Arama yap",
                          controller: _tSearch,
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (_tSearch.text.isNotEmpty) {
                                model.getSurveys(searchText: _tSearch.text);
                              }
                            },
                            icon: const Icon(Icons.search, size: 20),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _listWidget(model),
                      ],
                    ),
        ),
      ),
    );
  }

  Flexible _listWidget(SurveysViewModel model) {
    return Flexible(
      child: ListView.separated(
        itemCount: model.surveys!.length,
        itemBuilder: (context, index) {
          final SurveyModel surveyModel = model.surveys![index];
          return SurveyWidget(surveyModel: surveyModel);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
    );
  }
}
