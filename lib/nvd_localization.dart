import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Builds the localization context.
class NvdLocalization extends StatelessWidget {
  /// Builds the localization context.
  const NvdLocalization({required this.child});

  /// Child widget.
  final Widget child;

  /// Supported Locales.
  static const supportedLocales = [Locale('en'), Locale('fr')];

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      assetLoader: const _CustomAssetLoader(),
      supportedLocales: supportedLocales,
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      child: child,
    );
  }
}

class _CustomAssetLoader extends AssetLoader {
  const _CustomAssetLoader();

  String getLocalePath(String basePath, Locale locale) {
    final Locale effectiveLocale;
    effectiveLocale = Locale.fromSubtags(
      languageCode: locale.languageCode,
      scriptCode: locale.scriptCode,
    );
    return '$basePath/${effectiveLocale.toStringWithSeparator(separator: "-")}.json';
  }

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    final localePath = getLocalePath(path, locale);
    EasyLocalization.logger.debug('Load asset from $path');
    return json.decode(await rootBundle.loadString(localePath))
        as Map<String, dynamic>?;
  }
}
