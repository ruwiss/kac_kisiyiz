import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/content_service.dart';
import 'package:kac_kisiyiz/widgets/global/action_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInformationWidget extends StatefulWidget {
  const AppInformationWidget({super.key});

  @override
  State<AppInformationWidget> createState() => _AppInformationWidgetState();
}

class _AppInformationWidgetState extends State<AppInformationWidget> {
  String? _text;

  void _setText() {
    final settings = locator.get<ContentService>().settings;
    final surveyLimit =
        settings.singleWhere((e) => e.name == "surveyLimit").attr;
    final withdrawalLimit =
        settings.singleWhere((e) => e.name == "withdrawalLimit").attr;

    _text = """
Kaç Kişiyiz? uygulaması, kullanıcılara eğlenceli anketler sunarak gündemden haberdar olmalarını ve güzel vakit geçirip pasif gelir elde etmelerini amaçlar.

Uygulama içerisinde anketleri yanıtlayarak para kazanabilirsiniz. Günlük olarak sınırlandırılmış $surveyLimit anketten bazılarında ödül bulunmaktadır.

Ayrıca profil bölümünde bulunan "Anket Oluştur" butonuyla kendi anketlerinizi oluşturabilir ve bize destekte bulunabilirsiniz. Ayrıca oluşturduğunuz anketlere bağlı olarak ödüllendirilebilirsiniz.

Birikimleriniz $withdrawalLimit₺'e ulaştığında çekim talebinde bulunabilirsiniz.

Uygulama, kullanıcılara gösterdiği reklamlardan gelir elde etmektedir. Elde edilen gelire bağlı olarak ödüllü anketlerin sayısı artırılmaktadır.

Ne kadar çok kullanıcı, o kadar kazanç demek. Bu nedenle, uygulamaya Play Store üzerinden yorum atarak ve farklı kişilerle paylaşarak kazancınızı artırabilirsiniz.
""";
    setState(() {});
  }

  @override
  void initState() {
    _setText();
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
            "Uygulama Hakkında",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Text(
                  _text ?? "",
                  style: TextStyle(
                      color: Colors.black.withOpacity(.8), height: 1.5),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    final url = Uri.parse(
                        "https://play.google.com/store/apps/details?id=com.rw.kackisiyiz");
                    launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.indigo.withOpacity(.12)),
                  child: Text(
                    "Uygulamaya yıldız vermek için tıklayın",
                    style: TextStyle(
                        color: Colors.black.withOpacity(.7), height: 1.5),
                  ),
                ),
              ],
            )),
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

void showAppInformationBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const AppInformationWidget());
}
