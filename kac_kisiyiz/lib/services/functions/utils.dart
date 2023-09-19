import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';

class Utils {
  Future<void> startLoading(BuildContext context) async {
    return await showDialog(
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

  Future<void> stopLoading(BuildContext context) async =>
      Navigator.of(context).pop();

  Future<void> showError(BuildContext context, {String? error}) async {
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
}
