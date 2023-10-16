import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/auth_service.dart';
import 'package:kac_kisiyiz/services/backend/shared_preferences.dart';
import 'package:kac_kisiyiz/utils/consts.dart';
import 'package:kac_kisiyiz/widgets/features/auth/auth_action_buttons.dart';
import 'package:kac_kisiyiz/widgets/features/auth/backdrop_filter.dart';
import 'package:kac_kisiyiz/widgets/global/input_widgets/input_field.dart';
import 'package:kac_kisiyiz/widgets/global/action_button.dart';
import 'package:kac_kisiyiz/widgets/global/title_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  AuthType _authType = AuthType.login;
  bool _showAuthScreen = false;

  final _tName = TextEditingController();
  final _tMail = TextEditingController();
  final _tPass = TextEditingController();

  void _getUserFromDevice() async {
    final user = locator.get<MyDB>().getUser();
    if (user != null) {
      locator.get<AuthService>().resultData = user;
      Navigator.pushNamed(context, "/home");
    } else {
      _showAuthScreen = true;
      setState(() {});
      FlutterNativeSplash.remove();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _getUserFromDevice());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BackdropFilterAuth(
          child: !_showAuthScreen
              ? const CircularProgressIndicator(color: Colors.white)
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
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
                          InputField(
                            controller: _tName,
                            hintText: "İsminiz",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "İsmi boş bırakmayınız.";
                              }
                              return null;
                            },
                          ),
                        InputField(
                            controller: _tMail,
                            hintText: "Email Adresiniz",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Bu alanı boş bırakmayınız.";
                              } else if (!value.contains("@")) {
                                return "Doğru mail adresi giriniz.";
                              }
                              return null;
                            }),
                        InputField(
                          controller: _tPass,
                          hintText: "Şifreniz",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Bu alanı boş bırakmayınız.";
                            } else if (value.length < 5) {
                              return "Güçlü bir şifre deneyin.";
                            }
                            return null;
                          },
                        ),
                        if (_authType == AuthType.login)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, "/forgotPassword"),
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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                locator.get<AuthService>().auth(
                                    context: context,
                                    isLogin: true,
                                    mail: _tMail.text,
                                    password: _tPass.text);
                              }
                            },
                          ),
                        if (_authType == AuthType.register)
                          ActionButton(
                            text: "Aramıza Katıl",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                locator.get<AuthService>().auth(
                                    context: context,
                                    isLogin: false,
                                    name: _tName.text,
                                    mail: _tMail.text,
                                    password: _tPass.text);
                              }
                            },
                          ),
                        const SizedBox(height: 30)
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
