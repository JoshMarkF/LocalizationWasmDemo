import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:io';

import 'package:dart_style/dart_style.dart';

void main() {
  final json = _getJson();
  _generateFile(json: json);
}

final _argRegExp = RegExp(r'{\w*}');

/// Returns the [Map] object from `en.json`.
Map<String, dynamic>? _getJson() {
  try {
    final englishFile = File('assets/lang/en.json');
    final englishJson = englishFile.readAsStringSync();
    return convert.jsonDecode(englishJson) as Map<String, dynamic>;
  } on FileSystemException {
    log('English translation file en.json not found');
    return null;
  }
}

/// Class names separator.
const _separator = r'$';

/// Root class name.
const _publicClassName = 'TextKeys';

/// Documentation of the root class.
const _publicDocumentation = '/// The translation keys of Novade Lite.';

/// Path of the generated file.
const _generatedFilePath =
    'packages/translations/text_keys_shared/lib/src/text_keys.g.dart';

/// Generates the generated dart file.
void _generateFile({Map<String, dynamic>? json}) {
  final buffer =
      StringBuffer()..write('''
// ! GENERATED CODE - DO NOT MANUALLY EDIT.
// This file is auto-generated with `flutter pub run tool/localize.dart`.

import 'package:text_key/text_key.dart';

''');

  _LocalizationKey(json: json).declare(buffer: buffer);

  final file = File(_generatedFilePath);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  final content = buffer.toString();
  final formattedContent = DartFormatter(
    languageVersion: DartFormatter.latestLanguageVersion,
  ).format(content);
  file.writeAsStringSync(formattedContent);
}

/// Json object from `en.json`.
class _LocalizationKey {
  _LocalizationKey({this.json, this.location = const <String>[]})
    : children =
          json is Map
              ? (json as Map<String, dynamic>).entries
                  .map(
                    (entry) => _LocalizationKey(
                      json: entry.value,
                      location: [...location, entry.key],
                    ),
                  )
                  .toList()
              : const [];

  /// [String] or [Map<String, dynamic].
  final dynamic json;

  /// Children of the key.
  final List<_LocalizationKey> children;

  /// Location in the `en.json` file.
  final List<String> location;

  /// Whether it is all object or only a sub object from `en.json`.
  bool get isRoot => location.isEmpty;

  /// Class name.
  String get className =>
      '${isRoot ? '' : '_'}${[_publicClassName, ...location.map(_snakeToPascal)].join(_separator)}';

  /// Variable name.
  String get variableName => isRoot ? '' : location.last;

  /// Translation key.
  String get key => location.join('.');

  /// `true` if the key has children.
  bool get hasChildren => children.isNotEmpty;

  static const _pluralKeys = ['zero', 'one', 'two', 'few', 'many', 'other'];

  /// Declare it in the generated file.
  void declare({required StringBuffer buffer}) {
    if (isRoot) {
      // Add the doc.
      buffer.writeln(_publicDocumentation);
    }

    var classToExtend = 'TextKey';
    final isPlural =
        hasChildren && _pluralKeys.every((json as Map).containsKey);
    if (hasChildren) {
      if (isPlural) {
        classToExtend = 'TextKeyPlural';
      } else {
        classToExtend = 'TextKeyNode';
      }
    }

    // Class definition and constructor.
    buffer.write('''
${isRoot ? 'abstract ' : ''}class $className extends $classToExtend {${isRoot ? '\n  $_publicDocumentation' : ''}
  const $className(): super();
''');

    // Attributes.
    if (hasChildren) buffer.writeln();
    for (final child in children) {
      buffer.writeln(
        '  ${isRoot ? "static const" : "final"} ${child.variableName} = ${isRoot ? "" : "const "}${child.className}();',
      );
    }

    if (hasChildren) {
      // Handle the [] operator.
      buffer.write('''

  @override
  TextKeyBase operator [](String key) {
    switch (key) {
''');
      for (final child in children) {
        buffer.write('''
      case '${child.variableName}':
        return ${child.variableName};
''');
      }
      buffer.write('''
      default:
        return super[key];
    }
  }
''');
    }

    if (!hasChildren) {
      // Add the text key args method.
      buffer.write(_textKeyArgsMethod());
    } else if (isPlural) {
      // Add the plural text key args method.
      buffer.write(_pluralTextKeyArgsMethod());
    }

    // Adds toKeyString and end of class.
    buffer.write('''

  @override
  String toKeyString() => '$key';
}

''');

    for (final child in children) {
      child.declare(buffer: buffer);
    }
  }

  String _textKeyArgsMethod() {
    assert(
      json is String,
      'The json object should only be a Map<String, dynamic> or a String',
    );
    final buffer = StringBuffer();
    final text = json as String;
    final args =
        _argRegExp.allMatches(text).map((match) {
          final matchedText = match.group(0)!; // '{arg}'.
          return matchedText.substring(1, matchedText.length - 1); // 'arg'.
        }).toList();
    final numberOfPositionalArgs = args.where((args) => args.isEmpty).length;
    final namedArgs = args.where((args) => args.isNotEmpty).toList();
    buffer.write('''

  TextKeyWithArgs args(
''');
    if (numberOfPositionalArgs == 0 && namedArgs.isEmpty) {
      buffer.write(') {');
    } else {
      buffer.write('{');
      if (numberOfPositionalArgs > 0) {
        final String recordType;
        if (numberOfPositionalArgs > 1) {
          recordType =
              '(${List.generate(numberOfPositionalArgs, (_) => 'String').join(', ')})';
        } else {
          recordType = '(String,)';
        }
        buffer.write('''
    required $recordType args,
''');
      }
      for (final namedArg in namedArgs) {
        buffer.write('''
    required String $namedArg,
''');
      }
      buffer.write('''
  }) {
''');
    }

    buffer.write('''
    return TextKeyWithArgs(
      textKey: toKeyString(),
''');

    if (numberOfPositionalArgs > 0) {
      buffer.write('''
      args: [${List.generate(numberOfPositionalArgs, (index) => 'args.\$${index + 1}').join(', ')}],
''');
    }
    if (namedArgs.isNotEmpty) {
      buffer.write('''
      namedArgs: {${namedArgs.map((namedArg) => "'$namedArg': $namedArg").join(', ')}},
''');
    }

    buffer.write('''
    ); 
  }
''');
    return buffer.toString();
  }

  String _pluralTextKeyArgsMethod() {
    assert(
      json is Map && (json as Map)['other'] is String,
      'The `other` key should always be specified',
    );
    final buffer = StringBuffer();
    final text = (json as Map)['other'] as String;
    final args =
        _argRegExp.allMatches(text).map((match) {
          final matchedText = match.group(0)!; // '{arg}'.
          return matchedText.substring(1, matchedText.length - 1); // 'arg'.
        }).toList();
    final numberOfPositionalArgs = args.where((args) => args.isEmpty).length;
    final namedArgs = args.where((args) => args.isNotEmpty).toList();
    buffer.write('''

  PluralTextKeyWithArgs args({
    required num value,
''');
    if (numberOfPositionalArgs > 1) {
      // If there is only 1 positional argument, we don't need to add it to
      // the parameters. This will be the `value.
      final recordType =
          '(${List.generate(numberOfPositionalArgs, (_) => 'String').join(', ')})';
      buffer.write('''
    required $recordType args,
''');
    }
    for (final namedArg in namedArgs) {
      buffer.write('''
    required String $namedArg,
''');
    }
    buffer.write('''
  }) {
    return PluralTextKeyWithArgs(
      value: value,
      textKey: toKeyString(),
''');

    if (numberOfPositionalArgs > 1) {
      buffer.write('''
      args: [${List.generate(numberOfPositionalArgs, (index) => 'args.\$${index + 1}').join(', ')}],
''');
    }
    if (namedArgs.isNotEmpty) {
      buffer.write('''
      namedArgs: {${namedArgs.map((namedArg) => "'$namedArg': $namedArg").join(', ')}},
''');
    }

    buffer.write('''
    ); 
  }
''');
    return buffer.toString();
  }
}

/// Snake_case to PascalCase.
String _snakeToPascal(String snakeCase) =>
    snakeCase
        .split('_')
        .map((item) => item[0].toUpperCase() + item.substring(1).toLowerCase())
        .join();
