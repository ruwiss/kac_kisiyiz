import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kackisiyiz_panel/core/extensions/context_extensions.dart';

import '../../../core/models/survey_model.dart';

class SurveyWidget extends StatefulWidget {
  final SurveyModel surveyModel;
  const SurveyWidget({super.key, required this.surveyModel});

  @override
  State<SurveyWidget> createState() => _SurveyWidgetState();
}

class _SurveyWidgetState extends State<SurveyWidget> {
  bool _showButtons = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {},
      mouseCursor: MouseCursor.defer,
      onHover: (value) => setState(() => _showButtons = value),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.secondaryColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.surveyModel.title} Kaç Kişiyiz?"),
                Text(
                  widget.surveyModel.content,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                )
              ],
            ),
          ),
          if (_showButtons)
            Positioned(
              top: 0,
              right: 0,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.pushReplacement(Uri(
                              path: "/addSurvey",
                              queryParameters:
                                  widget.surveyModel.toJsonString())
                          .toString());
                    },
                    icon: const Icon(Icons.article, size: 17),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.close, size: 17, color: Colors.red),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
