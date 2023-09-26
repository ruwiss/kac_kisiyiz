import 'package:flutter/material.dart';
import 'package:kac_kisiyiz/locator.dart';
import 'package:kac_kisiyiz/services/backend/auth_service.dart';
import 'package:kac_kisiyiz/services/backend/content_service.dart';
import 'package:kac_kisiyiz/services/functions/utils.dart';
import 'package:kac_kisiyiz/services/models/categories_model.dart';
import 'package:kac_kisiyiz/services/models/user_model.dart';
import 'package:kac_kisiyiz/utils/colors.dart';
import 'package:kac_kisiyiz/widgets/global/action_button.dart';
import 'package:kac_kisiyiz/widgets/global/input_widgets/input_category.dart';
import 'package:kac_kisiyiz/widgets/global/input_widgets/input_field.dart';

class BankAccountWidget extends StatefulWidget {
  const BankAccountWidget({super.key});

  @override
  State<BankAccountWidget> createState() => _BankAccountWidgetState();
}

class _BankAccountWidgetState extends State<BankAccountWidget> {
  final _formKey = GlobalKey<FormState>();
  final _tNameSurname = TextEditingController();
  final _tIban = TextEditingController();
  int? _selectedCategoryId;

  late UserBankModel? _userBank;

  // ignore: prefer_final_fields
  List<CategoryModel> _bankCategories = [];

  CategoryModel _findBankBySingleValue({int? id, String? name}) {
    if (id != null) {
      return _bankCategories.singleWhere((e) => e.id == id);
    } else {
      return _bankCategories.singleWhere((e) => e.category == name);
    }
  }

  void _recoverUserBank() async {
    _userBank = locator.get<AuthService>().resultData.user!.bankAccount;
    if (_userBank != null) {
      _tNameSurname.text = _userBank!.nameSurname;
      _tIban.text = _userBank!.iban;
      _selectedCategoryId =
          _findBankBySingleValue(name: _userBank!.bankName).id;
      setState(() {});
    }
  }

  void _setBankCategories() {
    const List<String> banks = [
      "Papara",
      "Halkbank",
      "Vakıfbank",
      "Ziraat Bankası",
      "Akbank",
      "Fibabanka",
      "Şekerbank",
      "Türkiye İş Bankası",
      "Yapı Kredi",
      "Deniz Bank",
      "Garanti BBVA",
      "HSBC",
      "ICBC Turkey Bank",
      "ING",
      "Odeabank",
      "QNB Finansbank",
      "TEB"
    ];
    for (var i = 0; i < banks.length; i++) {
      _bankCategories.add(CategoryModel(id: i, category: banks[i]));
    }
  }

  @override
  void initState() {
    _setBankCategories();
    _recoverUserBank();
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
              "Ödeme Bilgileriniz",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            InputField(
              controller: _tNameSurname,
              hintText: "Ad Soyad",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Bu alanı boş bırakmayınız.";
                } else if (!value.contains(" ")) {
                  return "Tam bilgi veriniz.";
                }
                return null;
              },
            ),
            InputCategory(
              text: "Banka hesabınızı seçiniz",
              value: _selectedCategoryId,
              items: _bankCategories,
              onSelected: (value) => _selectedCategoryId = value,
            ),
            InputField(
              controller: _tIban,
              hintText: "IBAN / Cüzdan Kodu",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Bu alanı boş bırakmayınız.";
                }
                return null;
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 20),
              child: Text(
                "Bilgileriniz kazancınızı iletmek için gereklidir.\nKimseyle Paylaşılmayacaktır.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(
                  text: " SİL ",
                  backgroundColor: Colors.red.withOpacity(.75),
                  onPressed: () {
                    if (_userBank != null) {
                      Utils.showConfirmDialog(
                        context,
                        title: "Emin misin?",
                        message: "Ödeme yönteminiz silinecektir.",
                        buttonColor: KColors.redButtonColor,
                        onConfirm: () => locator
                            .get<ContentService>()
                            .deleteBankAccount(context),
                      );
                    }
                  },
                ),
                ActionButton(
                  text: "KAYDET",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final selectedBank =
                          _findBankBySingleValue(id: _selectedCategoryId);
                      locator.get<ContentService>().editBankAccount(context,
                          nameSurname: _tNameSurname.text,
                          bankName: selectedBank.category,
                          iban: _tIban.text);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showBankAccountBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const BankAccountWidget());
}
