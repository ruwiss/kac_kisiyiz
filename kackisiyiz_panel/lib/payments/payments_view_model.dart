import 'package:kackisiyiz_panel/payments/common/payments_api_service.dart';
import 'package:kackisiyiz_panel/payments/common/models/top_user_model.dart';
import 'package:kackisiyiz_panel/core/app/base_view_model.dart';

class PaymentsViewModel extends BaseViewModel {
  final _paymentsApiService = PaymentsApiService();
  List<TopUserModel>? topUsers;

  Future getTopUsers() async {
    setState(ViewState.busy);
    topUsers = await _paymentsApiService.getTopUsers();
    setState(ViewState.idle);
  }

  Future paymentCompleted(TopUserModel topUserModel) async {
    setState(ViewState.busy);
    if (await _paymentsApiService.reduceUserMoney(topUserModel)) {
      topUsers!.remove(topUserModel);
    }
    setState(ViewState.idle);
  }
}
