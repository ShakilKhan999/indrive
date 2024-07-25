import 'package:flutter/material.dart';
import 'package:indrive/utils/space_helper.dart';
import 'package:indrive/utils/style_helper.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeader(),
          SpaceHelper.verticalSpace10,
          _buildPhoneTextFiled(),
        ],
      ),
    );
  }

  Widget _buildPhoneTextFiled() {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {},

      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        useBottomSheetSafeArea: true,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: const TextStyle(color: Colors.black),
      // initialValue: number,
      // textFieldController: controller,
      formatInput: true,
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputBorder: const OutlineInputBorder(),
    );
  }

  Widget _buildHeader() =>
      Text('Join us via phone number', style: StyleHelper.heading);
}
