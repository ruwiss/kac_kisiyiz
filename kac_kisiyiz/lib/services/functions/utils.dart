import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';

class Utils {
  static Future startLoading(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0,
          backgroundColor:
              Colors.transparent, // can change this to your prefered color
          children: [
            Center(
              child: CircularProgressIndicator(color: KColors.secondary),
            )
          ],
        );
      },
    );
  }

  static Future stopLoading(BuildContext context) async =>
      Navigator.of(context).pop();

  static Future showError(BuildContext context, {String? error}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Kapat',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
        backgroundColor: Colors.red,
        content: Text(error ?? "Bir sorun oluştu."),
      ),
    );
  }

  static Future showInfo(BuildContext context,
      {required String message}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(message),
      ),
    );
  }

  static Future showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required Function() onConfirm,
  }) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("İptal")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(.6)),
            child: const Text(
              "Onayla",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
