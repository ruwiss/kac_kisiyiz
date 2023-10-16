import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/pages/home_page/tabs/profile/create_survey.dart';
import 'package:kac_kisiyiz/pages/home_page/tabs/profile/settings.dart';
import 'package:kac_kisiyiz/services/backend/auth_service.dart';
import 'package:kac_kisiyiz/services/models/user_model.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/utils/consts.dart';
import 'package:kac_kisiyiz/utils/images.dart';
import 'package:kac_kisiyiz/widgets/global/action_button.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel? user = locator.get<AuthService>().resultData.user;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: constraints.maxHeight,
              decoration: const BoxDecoration(
                color: KColors.primary,
                image: DecorationImage(
                  image: AssetImage(KImages.profilePattern),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  opacity: .1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15, right: 15, top: 100),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(kBorderRadius + 5),
                            topRight: Radius.circular(kBorderRadius + 5),
                          ),
                        ),
                        height: constraints.maxHeight * .8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 50),
                            Text(
                              user!.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            _profileItem(count: user.voteCount.toDouble(), text: "Cevaplanan Anket"),
                            _profileItem(count: user.money, text: "Kazandığın Miktar", isMoney: true),
                            ActionButton(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              onPressed: () => showCreateSurveyBottomSheet(context),
                              backgroundColor: KColors.primary.withOpacity(.95),
                              text: "Anket Oluştur",
                              elevation: 0,
                              textStyle: const TextStyle(
                                fontSize: kFontSizeButton + 3,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 5),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: KColors.primary,
                            child: Image.asset(KImages.profileSmile, scale: 3.3),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 4,
              right: 10,
              child: IconButton(
                onPressed: () => showSettingsBottomSheet(context),
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Container _profileItem({required double count, required String text, bool isMoney = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius + 10),
        border: Border.all(color: KColors.border, width: 2),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 3), // Shadow position
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isMoney ? "${count.toStringAsFixed(2)} ₺" : "${count.round()}",
            style: TextStyle(fontSize: isMoney ? 30 : 34, fontWeight: FontWeight.bold, color: KColors.primary),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 17),
          )
        ],
      ),
    );
  }
}
