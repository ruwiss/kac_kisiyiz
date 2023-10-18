import 'package:flutter/material.dart';
import 'package:kackisiyiz_panel/core/extensions/context_extensions.dart';
import 'package:kackisiyiz_panel/payments/payments_view_model.dart';
import 'package:kackisiyiz_panel/core/app/base_view.dart';
import '../core/app/base_view_model.dart';

class PaymentsView extends StatelessWidget {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<PaymentsViewModel>(
      onModelReady: (model) => model.getTopUsers(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Top 5 Kullanıcı",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  model.state == ViewState.busy
                      ? const Text("Bekleyiniz..")
                      : model.topUsers == null
                          ? const Text("Bir sorun oluştu")
                          : _listWidget(model)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Flexible _listWidget(PaymentsViewModel model) {
    return Flexible(
      child: model.topUsers != null && model.topUsers!.isEmpty
          ? const Text("Kazanan kullanıcı yok")
          : ListView.builder(
              itemCount: model.topUsers!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final topUserModel = model.topUsers![index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: context.secondaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText("${topUserModel.nameSurname ?? topUserModel.name}  ${topUserModel.mail}\nPara: ${topUserModel.money} TL  Oy Sayısı: ${topUserModel.voteCount}\nBanka: ${topUserModel.bankName}  IBAN: ${topUserModel.iban}".replaceAll("null", "Yok")),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          onPressed: () => model.paymentCompleted(topUserModel),
                          child: const Text(
                            "Ödül Ver",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
