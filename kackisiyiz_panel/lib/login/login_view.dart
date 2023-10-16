import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kackisiyiz_panel/login/login_view_model.dart';
import 'package:kackisiyiz_panel/core/app/base_view.dart';
import 'package:kackisiyiz_panel/core/widgets/textfield_input.dart';

// ignore: must_be_immutable
class LoginView extends StatelessWidget {
  LoginView({super.key});
  String? errorText;
  final _formKey = GlobalKey<FormState>();
  final _tMail = TextEditingController();
  final _tPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      onModelReady: (model) {
        _tMail.text = 'omer670067@gmail.com';
        _tPassword.text = 'V47R3JNT';
      },
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldInput(hint: "E-Posta", controller: _tMail),
                TextFieldInput(
                    hint: "Şifreniz", obscured: true, controller: _tPassword),
                if (model.infoText != null) Text(model.infoText!),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (await model.login(_tMail.text, _tPassword.text)) {
                        if (context.mounted) {
                          context.pushReplacementNamed("add");
                        }
                      } else {
                        model.setInfoText("Yanlış bilgi verdiniz.");
                      }
                    }
                  },
                  child: const Text('Giriş Yap'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
