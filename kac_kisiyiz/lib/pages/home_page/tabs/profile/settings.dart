import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';

void showSettingsBottomSheet(BuildContext context) {
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
