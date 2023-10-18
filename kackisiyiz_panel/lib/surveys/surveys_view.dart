import 'package:flutter/material.dart';
import 'package:kackisiyiz_panel/core/app/locator.dart';
import 'package:kackisiyiz_panel/core/models/survey_model.dart';
import 'package:kackisiyiz_panel/surveys/surveys_view_model.dart';
import 'package:kackisiyiz_panel/core/app/base_view.dart';
import 'package:kackisiyiz_panel/surveys/common/widgets/survey_widget.dart';
import 'package:kackisiyiz_panel/core/widgets/textfield_input.dart';
import '../core/app/base_view_model.dart';

enum SelectedFilter {
  pending,
  rewarded
}

class SurveysView extends StatefulWidget {
  const SurveysView({super.key});

  @override
  State<SurveysView> createState() => _SurveysViewState();
}

class _SurveysViewState extends State<SurveysView> {
  final _tSearch = TextEditingController();

  SelectedFilter _selectedFilter = SelectedFilter.pending;

  void _setSelectedFilter(SelectedFilter filter) async {
    setState(() => _selectedFilter = filter);
    locator<SurveysViewModel>().getSurveys(selectedFilter: filter);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SurveysViewModel>(
      onModelReady: (model) => model.getSurveys(selectedFilter: _selectedFilter),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(25),
            child: model.state == ViewState.busy
                ? const Center(child: Text("Bekleyiniz.."))
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
                                  model.getSurveys(searchText: _tSearch.text, selectedFilter: _selectedFilter);
                                }
                              },
                              icon: const Icon(Icons.search, size: 20),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _filterButton(SelectedFilter.pending, "Gönderilenler"),
                              _filterButton(SelectedFilter.rewarded, "Ödüllü Anketler"),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _listWidget(model),
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _filterButton(SelectedFilter filter, String text) => ElevatedButton(
        onPressed: _selectedFilter == filter ? null : () => _setSelectedFilter(filter),
        child: Text(
          text,
          style: const TextStyle(fontSize: 13),
        ),
      );

  Flexible _listWidget(SurveysViewModel model) {
    return Flexible(
      child: ListView.separated(
        itemCount: model.surveys!.length,
        itemBuilder: (context, index) {
          final SurveyModel surveyModel = model.surveys![index];
          return SurveyWidget(
            surveyModel: surveyModel,
            onDelete: () => model.deleteSurvey(surveyModel.id),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
    );
  }
}
