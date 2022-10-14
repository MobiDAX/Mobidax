import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpField extends StatelessWidget {
  const OtpField({
    this.onVerifyOTP,
    this.length,
    this.bgColor,
  });

  final Function onVerifyOTP;
  final int length;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      onChanged: (String value) {},
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: const TextInputType.numberWithOptions(),
      length: length ?? 6,
      dialogConfig: DialogConfig(
        affirmativeText: tr('confirm'),
        negativeText: tr('cancel'),
        dialogTitle: tr('2fa_paste'),
        dialogContent: tr(
          '2fa_paste_sentence',
        ),
      ),
      autoFocus: true,
      backgroundColor: bgColor ?? Theme.of(context).colorScheme.background,
      textStyle: Theme.of(context).textTheme.bodyText1.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
      pinTheme: PinTheme(
        fieldWidth: 30,
        shape: PinCodeFieldShape.underline,
        activeColor: Theme.of(context).colorScheme.primaryVariant,
        selectedColor: Theme.of(context).colorScheme.onBackground,
        inactiveColor: Theme.of(context).colorScheme.onBackground,
      ),
      enableActiveFill: false,
      autoDisposeControllers: true,
      showCursor: true,
      autoDismissKeyboard: true,
      onCompleted: (String value) {
        if (value.length == (length ?? 6)) {
          onVerifyOTP(value);
        }
      },
      onSubmitted: (String value) {
        if (value.length == (length ?? 6)) {
          onVerifyOTP(value);
        }
      },
    );
  }
}
