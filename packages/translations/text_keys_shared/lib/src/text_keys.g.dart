// ! GENERATED CODE - DO NOT MANUALLY EDIT.
// This file is auto-generated with `flutter pub run tool/localize.dart`.

import 'package:text_key/text_key.dart';

/// The translation keys of Novade Lite.
abstract class TextKeys extends TextKeyNode {
  /// The translation keys of Novade Lite.
  const TextKeys() : super();

  static const app_bar_title = _TextKeys$AppBarTitle();
  static const pushed_button_times = _TextKeys$PushedButtonTimes();
  static const increment = _TextKeys$Increment();

  @override
  TextKeyBase operator [](String key) {
    switch (key) {
      case 'app_bar_title':
        return app_bar_title;
      case 'pushed_button_times':
        return pushed_button_times;
      case 'increment':
        return increment;
      default:
        return super[key];
    }
  }

  @override
  String toKeyString() => '';
}

class _TextKeys$AppBarTitle extends TextKey {
  const _TextKeys$AppBarTitle() : super();

  TextKeyWithArgs args() {
    return TextKeyWithArgs(textKey: toKeyString());
  }

  @override
  String toKeyString() => 'app_bar_title';
}

class _TextKeys$PushedButtonTimes extends TextKey {
  const _TextKeys$PushedButtonTimes() : super();

  TextKeyWithArgs args() {
    return TextKeyWithArgs(textKey: toKeyString());
  }

  @override
  String toKeyString() => 'pushed_button_times';
}

class _TextKeys$Increment extends TextKey {
  const _TextKeys$Increment() : super();

  TextKeyWithArgs args() {
    return TextKeyWithArgs(textKey: toKeyString());
  }

  @override
  String toKeyString() => 'increment';
}
