import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/services/models/survey_model.dart';
import 'package:kac_kisiyiz/widgets/global/survey_widget.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSurveyWidget extends StatelessWidget {
  final bool small;
  const ShimmerSurveyWidget({super.key, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade100,
        highlightColor: Colors.grey.shade200,
        child: SurveyWidget(surveyModel: SurveyModel.dummy(), small: small, shimmer: true));
  }
}
