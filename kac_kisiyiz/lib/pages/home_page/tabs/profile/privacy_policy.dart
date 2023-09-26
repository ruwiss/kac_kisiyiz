import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/content_service.dart';
import 'package:kac_kisiyiz/widgets/global/action_button.dart';

class PrivacyPolicyWidget extends StatefulWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  State<PrivacyPolicyWidget> createState() => _PrivacyPolicyWidgetState();
}

class _PrivacyPolicyWidgetState extends State<PrivacyPolicyWidget> {
  String? _privacyPolicy;

  @override
  void initState() {
    locator.get<ContentService>().getPrivacyPolicy().then((value) {
      _privacyPolicy = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: _privacyPolicy == null
          ? const Text("Bekleyiniz..")
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Gizlilik Sözleşmesi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      _privacyPolicy!,
                      style: TextStyle(
                          color: Colors.black.withOpacity(.8), height: 1.7),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ActionButton(
                  text: "Kapat",
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.blueGrey.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                )
              ],
            ),
    );
  }
}

void showPrivacyPolicyBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const PrivacyPolicyWidget());
}
