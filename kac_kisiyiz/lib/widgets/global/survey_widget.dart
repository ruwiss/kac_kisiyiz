import 'dart:async';

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

enum SurveyChoices {
  ch1,
  ch2
}

class SurveyWidget extends StatefulWidget {
  const SurveyWidget({super.key, required this.surveyModel, this.small = false, this.shimmer = false});
  final SurveyModel surveyModel;
  final bool small;
  final bool shimmer;

  @override
  State<SurveyWidget> createState() => _SurveyWidgetState();
}

class _SurveyWidgetState extends State<SurveyWidget> {
  bool isClicked = false;

  void _setButtonState() {
    setState(() => isClicked = true);
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() => isClicked = false);
      timer.cancel();
    });
  }

  void _voteSurvey(BuildContext context, SurveyChoices ch) {
    _setButtonState();
    locator.get<ContentService>().voteSurvey(context, surveyModel: widget.surveyModel, choice: ch);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(kBorderRadius + 5), border: Border.all(color: KColors.primary)),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(kBorderRadius - 3),
                child: widget.surveyModel.imageUrl.isEmpty
                    ? _imagePlaceHolder()
                    : FadeInImage.assetNetwork(
                        placeholder: KImages.surveyPlaceholder,
                        image: widget.surveyModel.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 120,
                        imageErrorBuilder: (context, error, stackTrace) => _imagePlaceHolder(),
                      ),
              ),
              if (widget.surveyModel.userName != null)
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: _surveyCategory(widget.surveyModel.userName!, isUserName: true),
                ),
              Positioned(
                left: 8,
                top: 8,
                child: _surveyCategory(widget.surveyModel.category),
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
                    style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: widget.shimmer ? Colors.grey : null, fontSize: 13.5, color: Colors.black.withOpacity(.8)),
                    children: [
                      TextSpan(text: widget.surveyModel.title),
                      const TextSpan(text: " Kaç Kişiyiz?", style: TextStyle(color: KColors.primary))
                    ],
                  ),
                ),
                if (!widget.small) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.surveyModel.content!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      backgroundColor: widget.shimmer ? Colors.grey : null,
                    ),
                  ),
                ]
              ],
            ),
          ),
          Consumer<HomeProvider>(
            builder: (context, value, child) {
              final bool isVoted = value.isVotedSurvey(widget.surveyModel.id);
              return Flexible(
                child: Column(
                  children: [
                    const Expanded(child: SizedBox()),
                    AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        child: isVoted
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SurveyMembersChip(num: widget.surveyModel.choice1, positive: false),
                                  const SizedBox(width: 30),
                                  SurveyMembersChip(num: widget.surveyModel.choice2),
                                ],
                              )
                            : const SizedBox()),
                    const Expanded(child: SizedBox()),
                    AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: !isVoted && !widget.small
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ActionButton.outlined(
                                    text: " Yokum ",
                                    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onPressed: () => isClicked ? null : _voteSurvey(context, SurveyChoices.ch1),
                                  ),
                                  ActionButton(
                                    text: "Burdayım!",
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onPressed: () => isClicked ? null : _voteSurvey(context, SurveyChoices.ch2),
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _imagePlaceHolder() => Image.asset(KImages.surveyPlaceholder, height: 120);

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
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: isUserName ? 10 : 12, color: isUserName ? Colors.white : null),
      ),
    );
  }
}
