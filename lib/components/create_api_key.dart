import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account_screen_inputs.dart';
import 'spacers.dart';

class CreateApiKeyModel extends StatelessWidget {
  const CreateApiKeyModel({
    this.kid,
    this.secret,
  });

  final String kid;
  final String secret;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr('access_key'),
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ),
                textAlign: TextAlign.left,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                ),
                child: CopyField(
                  text: kid,
                ),
              )
            ],
          ),
          SpaceH30(),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(
                  6,
                ),
                child: Icon(
                  Icons.warning,
                  color: Colors.orange,
                  size: 40,
                ),
              ),
              Expanded(
                child: Text(
                  tr('row_1_secret_key'),
                  style: const TextStyle(
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                tr('row_2_be_retrieved'),
                style: const TextStyle(
                  color: Colors.orange,
                ),
              )
            ],
          ),
          SpaceH30(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr('secret_key'),
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ),
                textAlign: TextAlign.left,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                ),
                child: CopyField(
                  text: secret,
                ),
              )
            ],
          ),
          SpaceH30(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr('row_3_note'),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                tr('row_4_to_avoid'),
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
          SpaceH30(),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                tr('btn_confirm'),
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
