import 'package:easy_localization/easy_localization.dart';
import 'package:text_key/text_key.dart';

/// Extension on [TextKey] class.
extension TextKeyExtension on TextKey {
  /// Returns the translated corresponding string.
  String translate({
    @Deprecated('Use `args().translate()` instead of `translate(args: args)` to parse arguments in a safer way.') List<String>? args,
    @Deprecated('Use `args().translate()` instead of `translate(namedArgs: args)` to parse arguments in a safer way.') Map<String, String>? namedArgs,
  }) =>
      toKeyString().tr(args: args, namedArgs: namedArgs);
}

/// An extension on [TextKeyWithArgs] class.
extension TextKeyWithArgsExtension on TextKeyWithArgs {
  /// Returns the safely translated corresponding string.
  String translate() => textKey.tr(args: args, namedArgs: namedArgs);
}

/// Extension on [TextKeyPlural] class.
extension TextKeyPluralExtension on TextKeyPlural {
  /// Plural method from easy localization.
  String plural(
    num value, {
    NumberFormat? format,
  }) =>
      toKeyString().plural(value, format: format);
}

/// An extension on [TextKeyWithArgs] class.
extension PluralTextKeyWithArgsExtension on PluralTextKeyWithArgs {
  /// Returns the safely translated corresponding string.
  String plural({NumberFormat? format}) => textKey.plural(value, args: args, namedArgs: namedArgs, format: format);
}

/// Extension on [String] for utils methods.
extension LocalizedString on String {
  /// Truncate a string and replace the end with ...
  String shorten({int maxLength = 8}) {
    return length <= maxLength ? this : '${substring(0, maxLength - 3)}...';
  }

  /// Function to get the initials of the words of a string.
  String get initials {
    var initials = '';
    // Remove special characters from string.
    final from = RegExp('[\\[\\]`!@#\$%^*+={};\':"\\\\|\\/,<>?~._-]');
    final cleanString = replaceAll(from, ' ');
    cleanString.split(' ').forEach((word) {
      if (word != '') initials += word.substring(0, 1);
    });
    return initials;
  }

  /// Get the URL key for the helpdesk portal based on the language set in the
  /// system.
  String get helpdeskLanguageKeyUrl {
    switch (this) {
      case 'en':
        return 'en_US';
      case 'fr':
        return 'fr';
      case 'ja':
        return 'ja';
      case 'id':
        return 'in';
      case 'zh':
        return 'zh_TW';
      default:
        return 'en_US';
    }
  }
}
