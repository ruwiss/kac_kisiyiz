import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kackisiyiz_panel/core/extensions/context_extensions.dart';

import '../../../core/models/survey_model.dart';

class SurveyWidget extends StatefulWidget {
  final SurveyModel surveyModel;
  final Function()? onDelete;
  const SurveyWidget({super.key, required this.surveyModel, this.onDelete});

  @override
  State<SurveyWidget> createState() => _SurveyWidgetState();
}

class _SurveyWidgetState extends State<SurveyWidget> {
  bool _showButtons = false;

  void _showButtonsVisibility({bool? value, bool isHover = false}) {
    if (Platform.isAndroid && !isHover) {
      setState(() => _showButtons = true);
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => _showButtons = false);
        timer.cancel();
      });
    } else if (isHover) {
      setState(() => _showButtons = value!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPending = widget.surveyModel.isPending;
    final double? rewarded = widget.surveyModel.isRewarded;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _showButtonsVisibility(),
      onHover: (value) => _showButtonsVisibility(value: value, isHover: true),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isPending ? Colors.brown[900] : context.secondaryColor,
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
              child: Container(
                color: Colors.black26,
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    if (rewarded != null && rewarded != 0.0) Text("$rewarded ₺"),
                    IconButton(
                      onPressed: () {
                        context.pushReplacement(Uri(path: "/addSurvey", queryParameters: widget.surveyModel.toJsonString()).toString());
                      },
                      icon: const Icon(Icons.article, size: 17),
                    ),
                    IconButton(
                      onPressed: () {
                        if (widget.onDelete != null) widget.onDelete!();
                      },
                      icon: const Icon(Icons.close, size: 17, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
