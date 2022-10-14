import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/spacers.dart';
import '../../helpers/sizes_helpers.dart';

class FormComponent extends StatelessWidget {
  const FormComponent({
    this.heading,
    this.content,
    this.bgColor,
  });

  final Widget heading;
  final Widget content;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Align(
        alignment: Alignment.center,
        child: Container(
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.center,
            direction: Axis.vertical,
            children: <Widget>[
              SizedBox(
                height: displayHeight(context) * 0.15,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    color: bgColor ?? Theme.of(context).colorScheme.primary,
                    width: 440.0,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          heading,
                          Divider(
                            thickness: 2,
                            color: Theme.of(context).colorScheme.primaryVariant,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/logo.svg',
                              ),
                            ),
                          ),
                          content,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
