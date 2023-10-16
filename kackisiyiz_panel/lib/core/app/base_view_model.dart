import 'dart:async';
import 'package:flutter/material.dart';

enum ViewState {idle, busy}

abstract class BaseViewModel with ChangeNotifier {
  String? infoText;
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  setInfoText(String? text) {
    infoText = text;
    notifyListeners();
    if (text != null) {
      Timer.periodic(const Duration(seconds: 2), (timer) {
        timer.cancel();
        setInfoText(null);
      });
    }
  }

  setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
