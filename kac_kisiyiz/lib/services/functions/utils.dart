import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';

class Utils {
  static Future startLoading(BuildContext context, {String? text}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          elevation: 0,
          backgroundColor: Colors.transparent, // can change this to your prefered color
          children: [
            Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(color: KColors.secondary),
                  if (text != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      text,
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ]
                ],
              ),
            )
          ],
        );
      },
    );
  }

  static void stopLoading(BuildContext context) => Navigator.of(context).pop();

  static Future showError(BuildContext context, {String? error}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text(error ?? "Bir sorun oluştu."),
      ),
    );
  }

  static Future showInfo(BuildContext context, {required String message}) async {
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
    required Color buttonColor,
  }) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
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
