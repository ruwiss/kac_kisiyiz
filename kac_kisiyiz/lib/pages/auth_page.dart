import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/auth_service.dart';
import 'package:kac_kisiyiz/utils/consts.dart';
import 'package:kac_kisiyiz/utils/images.dart';
import 'package:kac_kisiyiz/widgets/features/auth/auth_action_buttons.dart';
import 'package:kac_kisiyiz/widgets/global/input_widgets/input_field.dart';
import 'package:kac_kisiyiz/widgets/global/action_button.dart';
import 'package:kac_kisiyiz/widgets/global/title_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthType _authType = AuthType.login;

  final _tName = TextEditingController();
  final _tMail = TextEditingController();
  final _tPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _tMail.text = "omer670067@gmail.com";
    _tPass.text = "1234567890";
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 34),
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                opacity: .5,
                image: AssetImage(
                  KImages.authBackground,
                ),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 40),
                      child: TitleWidget.big(),
                    ),
                    AuthActionButtons(
                      onChanged: (type) => setState(() => _authType = type),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Text(
                        _authType == AuthType.login
                            ? "Kazandıran anket uygulamasına hoş geldin!"
                            : "Bilgileri doldurarak katılabilirsiniz.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (_authType == AuthType.register)
                      InputField(controller: _tName, hintText: "Ad Soyadınız"),
                    InputField(controller: _tMail, hintText: "Email Adresiniz"),
                    InputField(
                      controller: _tPass,
                      hintText: "Şifreniz",
                      obscureText: true,
                    ),
                    if (_authType == AuthType.login)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Şifremi Unuttum",
                            style: TextStyle(
                              letterSpacing: kLetterSpacing,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (_authType == AuthType.login)
                      ActionButton(
                        text: "Devam et",
                        onPressed: () => locator.get<AuthService>().auth(
                            context: context,
                            isLogin: true,
                            mail: _tMail.text,
                            password: _tPass.text),
                      ),
                    if (_authType == AuthType.register)
                      ActionButton(
                        text: "Aramıza Katıl",
                        onPressed: () => locator.get<AuthService>().auth(
                            context: context,
                            isLogin: false,
                            name: _tName.text,
                            mail: _tMail.text,
                            password: _tPass.text),
                      ),
                    const SizedBox(height: 30)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
