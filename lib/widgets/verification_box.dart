import 'package:flutter/material.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';

class VerificationBox extends StatelessWidget {
  final String langCode;
  final String translationKey;
  const VerificationBox({super.key, required this.langCode, required this.translationKey});

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<Localization>();
    return Row(
      children: [
        Text("${tr("verified")}: "),
        Checkbox(
          value: localization.dataManager.isVerifiedTranslation(
            langCode: langCode,
            key: translationKey,
          ),
          onChanged: (bool? value) {
            localization.dataManager.toggleVerifiedTranslation(
              langCode: langCode,
              key: translationKey
            );
            localization.notify();
          },
        ),
      ],
    );
  }
}
