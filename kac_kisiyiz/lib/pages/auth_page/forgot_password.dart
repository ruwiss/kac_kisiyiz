import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/auth_service.dart';
import 'package:kac_kisiyiz/services/providers/auth_provider.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/widgets/features/auth/backdrop_filter.dart';
import 'package:kac_kisiyiz/widgets/global/action_button.dart';
import 'package:kac_kisiyiz/widgets/global/input_widgets/input_field.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _tMail = TextEditingController();
  final _tCode = TextEditingController();
  final _tPassword = TextEditingController();

  void _getCode(AuthProvider value) async {
    if (_formKey.currentState!.validate()) {
      value.startTimerForResetPassword();
      locator.get<AuthService>().forgotPassword(context, mail: _tMail.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BackdropFilterAuth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              _titleWidget(context),
              const SizedBox(height: 45),
              Form(
                key: _formKey,
                child: Consumer<AuthProvider>(
                  builder: (context, value, child) {
                    bool timerStarted = value.timerForResetPassword != null;
                    return !value.codeVerified
                        ? Column(
                            children: [
                              InputField(
                                controller: _tMail,
                                isDisabled: timerStarted,
                                hintText: "Mail adresiniz",
                                widget: TextButton(
                                  onPressed: !timerStarted
                                      ? () => _getCode(value)
                                      : null,
                                  child: Text(
                                    "${value.timerForResetPassword ?? 'Kod al'}",
                                    style: const TextStyle(
                                        color: KColors.primary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return "Bu alanı boş bırakmayınız.";
                                  } else if (!v.contains("@")) {
                                    return "Doğru mail adresi giriniz.";
                                  }
                                  return null;
                                },
                              ),
                              if (value.showCodeInputField) ...[
                                InputField(
                                  controller: _tCode,
                                  hintText: "Kod",
                                  validator: (v) {
                                    if (timerStarted &&
                                        v != null &&
                                        v.length != 5) {
                                      return "5 haneli kodu giriniz.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ActionButton(
                                      text: "ONAYLA",
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          locator.get<AuthService>().verifyCode(
                                              context,
                                              mail: _tMail.text,
                                              code: _tCode.text);
                                        }
                                      },
                                      textStyle: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 10)),
                                ),
                              ]
                            ],
                          )
                        : Column(
                            children: [
                              InputField(
                                controller: _tPassword,
                                hintText: "Yeni şifre",
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Yeni şifreni girmelisin.";
                                  } else if (value.length < 5) {
                                    return "Güçlü bir şifre oluşturun.";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ActionButton(
                                    text: "DEVAM ET",
                                    backgroundColor: Colors.blue.shade400,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        locator
                                            .get<AuthService>()
                                            .resetPassword(
                                              context,
                                              code: _tCode.text,
                                              password: _tPassword.text,
                                            );
                                      }
                                    },
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10)),
                              ),
                            ],
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _titleWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: KColors.primary,
          ),
        ),
        const Expanded(child: SizedBox()),
        const Text(
          "Şifre Sıfırlama",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: KColors.primary),
        ),
        const SizedBox(width: 30),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
