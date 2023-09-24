import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/pages/home_page/tabs/profile/bank_account.dart';
import 'package:kac_kisiyiz/pages/home_page/tabs/profile/privacy_policy.dart';
import 'package:kac_kisiyiz/services/backend/auth_service.dart';
import 'package:kac_kisiyiz/services/backend/content_service.dart';
import 'package:kac_kisiyiz/services/functions/utils.dart';
import 'package:kac_kisiyiz/services/providers/settings_provider.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';

void showSettingsBottomSheet(BuildContext context) {
  if (locator.get<SettingsProvider>().userBank == null) {
    locator.get<ContentService>().getBankAccount();
  }
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
          settingsItem(
            text: "Ödeme Bilgileri",
            onTap: () {
              Navigator.pop(context);
              showBankAccountBottomSheet(context);
            },
          ),
          settingsItem(
            text: "Gizlilik Sözleşmesi",
            onTap: () {
              showPrivacyPolicyBottomSheet(context);
            },
          ),
          settingsItem(
            text: "Çıkış Yap",
            onTap: () => Utils.showConfirmDialog(
              context,
              title: "Emin misin?",
              message:
                  "(${locator.get<AuthService>().resultData.user!.mail})\nHesaptan çıkış yapılıyor.",
                  buttonColor: KColors.redButtonColor,
              onConfirm: () {
                locator.get<AuthService>().signOut(context);
              },
            ),
          ),
          settingsItem(
              text: "Hesabımı Sil",
              onTap: () => Utils.showConfirmDialog(context,
                  title: "Emin misin?",
                  message: "Hesabınız kalıcı olarak silinecektir.",
                  buttonColor: KColors.redButtonColor,
                  onConfirm: () =>
                      locator.get<ContentService>().deleteUserAccount(context)),
              color: Colors.red.withOpacity(.2)),
        ],
      ),
    ),
  );
}
