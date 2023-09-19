import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/content_service.dart';
import 'package:kac_kisiyiz/services/providers/home_provider.dart';
import 'package:kac_kisiyiz/widgets/global/action_button.dart';
import 'package:kac_kisiyiz/widgets/global/input_widgets/input_category.dart';
import 'package:kac_kisiyiz/widgets/global/input_widgets/input_field.dart';
import 'package:provider/provider.dart';

class CreateSurveyWidget extends StatefulWidget {
  const CreateSurveyWidget({super.key});

  @override
  State<CreateSurveyWidget> createState() => _CreateSurveyWidgetState();
}

class _CreateSurveyWidgetState extends State<CreateSurveyWidget> {
  @override
  void initState() {
    locator.get<ContentService>().getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Anket Oluştur",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          InputField(hintText: "Başlık", isMultiline: true),
          Consumer<HomeProvider>(
            builder: (context, value, child) => InputCategory(
              items: value.categories.map((e) => e.category).toList(),
              onSelected: (value) => print(value),
            ),
          ),
          InputField(
            hintText: "İçerik Metni",
            isMultiline: true,
            minLines: 3,
          ),
          const Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 20),
            child: Text(
              "Anketiniz onaylandığında bildirim alacaksınız.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ),
          ActionButton(text: "İnceleme için Gönder"),
        ],
      ),
    );
  }
}

void showCreateSurveyBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => CreateSurveyWidget());
}
