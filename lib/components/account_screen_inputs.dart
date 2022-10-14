import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helpers/error_notifier.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    this.text,
    this.validEmail,
    this.onValidateEmail,
    this.isSignIn,
  });

  final String text;
  final Function(String, bool) onValidateEmail;
  final bool validEmail;
  final bool isSignIn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        keyboardType: TextInputType.emailAddress,
        onChanged: (String input) {
          onValidateEmail(
            input,
            isSignIn,
          );
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 10,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
          ),
          hintText: text,
          hintStyle: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    this.text,
    this.onValidatePass,
    this.validPass,
    this.isSignIn,
  });

  final String text;
  final Function(String, bool) onValidatePass;
  final bool validPass;
  final isSignIn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: TextFormField(
        cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        obscureText: true,
        onChanged: (String input) {
          onValidatePass(
            input,
            isSignIn,
          );
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 10,
          ),
          hintText: text,
          hintStyle: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class AccountButton extends StatelessWidget {
  const AccountButton({
    this.text,
    this.onPressed,
    this.textColor,
    this.buttonColor,
  });

  final String text;
  final Function() onPressed;
  final Color textColor;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
              primary: buttonColor ??
                  Theme.of(context).buttonTheme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              textStyle: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                    color: textColor,
                  ),
            ),
            onPressed: onPressed,
            child: Text(
              text,
              style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                    color: (onPressed == null)
                        ? Theme.of(context).colorScheme.onPrimary
                        : textColor,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class CopyField extends StatelessWidget {
  const CopyField({
    this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          8,
        ),
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primaryVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).primaryTextTheme.caption.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.content_copy,
            ),
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text: text,
                ),
              );
              SnackBarNotifier.createSnackBar(
                tr('copied'),
                context,
              );
            },
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
    );
  }
}

class ReferralInput extends StatelessWidget {
  const ReferralInput({
    this.text,
    this.onSetReferralCode,
  });

  final String text;
  final Function(String) onSetReferralCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: TextFormField(
        cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        obscureText: true,
        onChanged: (String input) {
          onSetReferralCode(input);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 10,
          ),
          hintText: text,
          hintStyle: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
          ),
        ),
      ),
    );
  }
}
