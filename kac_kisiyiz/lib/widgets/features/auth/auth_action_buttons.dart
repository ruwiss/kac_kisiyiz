import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';

enum AuthType { login, register }

class AuthActionButtons extends StatefulWidget {
  const AuthActionButtons({super.key, required this.onChanged});
  final Function(AuthType) onChanged;

  @override
  State<AuthActionButtons> createState() => _AuthActionButtonsState();
}

class _AuthActionButtonsState extends State<AuthActionButtons> {
  AuthType _selected = AuthType.login;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: KColors.primary,
          border: Border.all(width: kBorderWidth, color: KColors.primary),
          borderRadius: BorderRadius.circular(kBorderRadius)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kBorderRadius - 2),
        child: Row(
          children: [
            _actionButton(AuthType.login),
            _actionButton(AuthType.register)
          ],
        ),
      ),
    );
  }

  Widget _actionButton(AuthType type) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _selected = type);
          widget.onChanged(type);
        },
        child: Container(
          color: _selected == type ? KColors.primary : Colors.white,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(13),
          child: Text(
            type == AuthType.login ? "Giriş Yap" : "Bize Katıl",
            style: TextStyle(
                letterSpacing: kLetterSpacing,
                fontWeight: FontWeight.w700,
                fontSize: kFontSizeButton,
                color: _selected == type ? Colors.white : null),
          ),
        ),
      ),
    );
  }
}
