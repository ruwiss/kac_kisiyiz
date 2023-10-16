import 'package:flutter/material.dart';
import 'package:kackisiyiz_panel/core/app/base_view_model.dart';
import 'package:kackisiyiz_panel/core/widgets/bottom_menu.dart';
import 'package:provider/provider.dart';
import 'locator.dart';

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T model)? onModelReady;

  const BaseView({super.key, required this.builder, this.onModelReady});

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.onModelReady?.call(model));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Consumer<T>(builder: widget.builder)),
        const BottomMenu(),
      ],
    );
  }
}
