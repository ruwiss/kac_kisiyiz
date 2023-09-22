import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/content_service.dart';
import 'package:kac_kisiyiz/services/models/survey_model.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';
import 'package:kac_kisiyiz/utils/images.dart';
import 'package:kac_kisiyiz/widgets/features/home/survey_members_chip.dart';
import 'package:kac_kisiyiz/widgets/global/action_button.dart';
import 'package:provider/provider.dart';

enum SurveyChoices { ch1, ch2 }

class SurveyWidget extends StatelessWidget {
  const SurveyWidget(
      {super.key, required this.surveyModel, this.small = false});
  final SurveyModel surveyModel;
  final bool small;

  void _voteSurvey(SurveyChoices ch) {
    locator
        .get<ContentService>()
        .voteSurvey(surveyModel: surveyModel, choice: ch);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius + 5),
          border: Border.all(color: KColors.primary)),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(kBorderRadius - 3),
                  child: FadeInImage.assetNetwork(
                    placeholder: KImages.surveyPlaceholder,
                    image: surveyModel.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  )),
              Positioned(
                right: 5,
                bottom: 5,
                child: _surveyCategory(surveyModel.userName, isUserName: true),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: _surveyCategory(surveyModel.category),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                Text.rich(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  TextSpan(
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: Colors.black.withOpacity(.8)),
                    children: [
                      TextSpan(text: surveyModel.title),
                      const TextSpan(
                          text: " Kaç Kişiyiz?",
                          style: TextStyle(color: KColors.primary))
                    ],
                  ),
                ),
                if (!small) ...[
                  const SizedBox(height: 12),
                  Text(
                    surveyModel.content!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ]
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Consumer<HomeProvider>(
            builder: (context, value, child) {
              final bool isVoted = value.isVotedSurvey(surveyModel.id);
              return Expanded(
                child: Column(
                  children: [
                    AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        child: isVoted
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SurveyMembersChip(
                                      num: surveyModel.choice1,
                                      positive: false),
                                  const SizedBox(width: 30),
                                  SurveyMembersChip(num: surveyModel.choice2),
                                ],
                              )
                            : const SizedBox()),
                    const Expanded(child: SizedBox()),
                    AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        child: !isVoted && !small
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ActionButton.outlined(
                                    text: "Yokum",
                                    onPressed: () =>
                                        _voteSurvey(SurveyChoices.ch1),
                                  ),
                                  ActionButton(
                                    text: "Burdayım!",
                                    onPressed: () =>
                                        _voteSurvey(SurveyChoices.ch2),
                                  )
                                ],
                              )
                            : const SizedBox()),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _surveyCategory(String text, {bool isUserName = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: isUserName ? Colors.black38 : Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadius),
        boxShadow: isUserName
            ? null
            : const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(3, 4), // Shadow position
                ),
              ],
      ),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: isUserName ? 10 : 13,
            color: isUserName ? Colors.white : null),
      ),
    );
  }
}
