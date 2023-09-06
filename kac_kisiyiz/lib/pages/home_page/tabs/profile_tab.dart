import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';
import 'package:kac_kisiyiz/utils/images.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  void _showSettings(BuildContext context) {
    Widget settingsItem(
            {required String text, Function()? onTap, Color? color}) =>
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: InkWell(
            splashColor: KColors.primary.withOpacity(.15),
            borderRadius: BorderRadius.circular(kBorderRadius - 5),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorderRadius - 5),
                  border: Border.all(color: KColors.border, width: 2),
                  color: color),
              child: Text(
                text,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        );

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(15),
        height: 360,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Ayarlar",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            settingsItem(text: "Ödeme Bilgileri", onTap: () {}),
            settingsItem(text: "Gizlilik Sözleşmesi", onTap: () {}),
            settingsItem(text: "Çıkış Yap", onTap: () {}),
            settingsItem(
                text: "Hesabımı Sil",
                onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Emin misin?"),
                        content:
                            const Text("Hesabınız kalıcı olarak silinecektir."),
                        actions: [
                          ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("İptal")),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.redAccent.withOpacity(.6)),
                            child: const Text(
                              "Onayla",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                color: Colors.red.withOpacity(.2)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: constraints.maxHeight,
              decoration: const BoxDecoration(
                color: KColors.primary,
                image: DecorationImage(
                  image: AssetImage(KImages.profilePattern),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  opacity: .1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(left: 15, right: 15, top: 100),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(kBorderRadius + 5),
                        topRight: Radius.circular(kBorderRadius + 5),
                      ),
                    ),
                    height: constraints.maxHeight * .8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 50),
                        const Text(
                          "Ömer G",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        _profileItem(count: 9, text: "Cevaplanan Anket"),
                        _profileItem(
                            count: 22.40,
                            text: "Kazandığın Miktar",
                            isMoney: true),
                        InkWell(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                          splashColor: Colors.white,
                          highlightColor: Colors.white,
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            decoration: BoxDecoration(
                              color: KColors.primary.withOpacity(.9),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                            ),
                            child: const Text(
                              "Anket Oluştur",
                              style: TextStyle(
                                fontSize: kFontSizeButton + 3,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 10,
              child: IconButton(
                onPressed: () => _showSettings(context),
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 100,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: KColors.primary,
                  child: Image.asset(KImages.profileSmile, scale: 3.3),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Container _profileItem(
      {required double count, required String text, bool isMoney = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius + 10),
        border: Border.all(color: KColors.border, width: 2),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 3), // Shadow position
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isMoney ? "$count ₺" : "${count.round()}",
            style: TextStyle(
                fontSize: isMoney ? 30 : 34,
                fontWeight: FontWeight.bold,
                color: KColors.primary),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 17),
          )
        ],
      ),
    );
  }
}
