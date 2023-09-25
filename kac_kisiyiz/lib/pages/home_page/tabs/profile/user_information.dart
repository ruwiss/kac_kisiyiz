import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/auth_service.dart';
import 'package:kac_kisiyiz/services/backend/content_service.dart';
import 'package:kac_kisiyiz/services/functions/utils.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/widgets/global/action_button.dart';
import 'package:kac_kisiyiz/widgets/global/input_widgets/input_field.dart';

class UserInformationWidget extends StatefulWidget {
  const UserInformationWidget({super.key});

  @override
  State<UserInformationWidget> createState() => _UserInformationWidgetState();
}

class _UserInformationWidgetState extends State<UserInformationWidget> {
  final _formKey = GlobalKey<FormState>();
  final _tName = TextEditingController();
  final _tOldPassword = TextEditingController();
  final _tPassword = TextEditingController();

  bool _nameDisabled = true;
  bool _passwordDisabled = true;

  String _errorText = "";

  void _getUserName() {
    final user = locator.get<AuthService>().resultData.user!;
    _tName.text = user.name;
  }

  @override
  void initState() {
    _getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Kullanıcı Bilgileriniz",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            InputField(
              controller: _tName,
              hintText: "İsim",
              icon: _nameDisabled ? Icons.edit_note : Icons.close,
              iconClicked: () {
                setState(() {
                  _nameDisabled = !_nameDisabled;
                  _getUserName();
                });
              },
              isDisabled: _nameDisabled,
              validator: (value) {
                if (!_nameDisabled) {
                  if (value == null || value.isEmpty) {
                    return "Bu alanı boş bırakmayınız.";
                  } else if (!value.contains(" ")) {
                    return "Tam bilgi veriniz.";
                  } else if (value.length > 20 || value.length < 5) {
                    return "Uzunluğa dikkat ediniz.";
                  }
                }
                return null;
              },
            ),
            InputField(
              controller: _tPassword,
              isDisabled: _passwordDisabled,
              icon: _passwordDisabled ? Icons.edit_note : Icons.close,
              iconClicked: () {
                setState(() {
                  _passwordDisabled = !_passwordDisabled;
                  _tPassword.clear();
                });
              },
              hintText: "Yeni Şifre",
              obscureText: true,
              validator: (value) {
                if (!_passwordDisabled) {
                  if (value == null || value.isEmpty) {
                    return "Bu alanı boş bırakmayınız.";
                  } else if (value.length < 5) {
                    return "Güçlü bir şifre deneyin.";
                  }
                }
                return null;
              },
            ),
            if (!_passwordDisabled)
              InputField(
                controller: _tOldPassword,
                hintText: "Mevcut Şifre",
                obscureText: true,
                validator: (value) {
                  if (!_passwordDisabled) {
                    if (value == null || value.isEmpty) {
                      return "Bu alanı boş bırakmayınız.";
                    } else if (value.length < 5) {
                      return "Güçlü bir şifre deneyin.";
                    }
                  }
                  return null;
                },
              ),
            if (_errorText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15),
                child: Text(
                  _errorText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            const SizedBox(height: 5),
            ActionButton(
              text: "KAYDET",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Map<String, dynamic> data = {};
                  if (!_nameDisabled) {
                    data['name'] = _tName.text;
                  }
                  if (!_passwordDisabled) {
                    data['newPassword'] = _tPassword.text;
                    data['oldPassword'] = _tOldPassword.text;
                  }
                  changeInformation() =>
                      locator.get<ContentService>().changeUserInformation(
                        context,
                        data,
                        onError: (e) {
                          setState(() => _errorText = e);
                        },
                      );

                  if (_passwordDisabled) {
                    changeInformation();
                  } else {
                    Utils.showConfirmDialog(
                      context,
                      title: "Bilgilendirme",
                      message:
                          "Şifre değişimi sonrası yeniden giriş yapmak gereklidir.",
                      onConfirm: () => changeInformation(),
                      buttonColor: KColors.primary,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

void showUserInformationBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const UserInformationWidget());
}
