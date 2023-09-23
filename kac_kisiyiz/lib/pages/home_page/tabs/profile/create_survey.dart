import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/content_service.dart';
import 'package:kac_kisiyiz/services/functions/utils.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _tTitle = TextEditingController();
  final _tContent = TextEditingController();
  int? _selectedCategoryId;

  @override
  void initState() {
    locator.get<ContentService>().getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: _formKey,
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
            InputField(
              controller: _tTitle,
              hintText: "Başlık",
              isMultiline: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Bu alanı boş bırakmayınız.";
                } else if (value.length < 10) {
                  return "Başlığınızın uzunluğu çok az";
                }
                return null;
              },
            ),
            Consumer<HomeProvider>(
              builder: (context, value, child) => InputCategory(
                items: value.categories,
                onSelected: (value) => _selectedCategoryId = value,
              ),
            ),
            InputField(
              controller: _tContent,
              hintText: "İçerik Metni",
              isMultiline: true,
              minLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Bu alanı boş bırakmayınız.";
                } else if (value.length < 10) {
                  return "İçeriğin uzunluğu çok az";
                }
                return null;
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 20),
              child: Text(
                "Anketiniz onaylandığında bildirim alacaksınız.\nPaylaştığınız ankete bağlı olarak ödüllendirilebilirsiniz.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ),
            ActionButton(
              text: "İnceleme için Gönder",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  locator.get<ContentService>().postSurvey(
                        context,
                        categoryId: _selectedCategoryId,
                        title: _tTitle.text,
                        content: _tContent.text,
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

void showCreateSurveyBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const CreateSurveyWidget());
}
