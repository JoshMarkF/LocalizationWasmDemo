/// A base class that represents a text key with arguments.
class _TextKeyWithArgsBase {
  /// A base class that represents a text key with arguments.
  const _TextKeyWithArgsBase({
    required this.textKey,
    this.args,
    this.namedArgs,
  });

  /// The text key.
  final String textKey;

  /// The positional arguments.
  final List<String>? args;

  /// The named arguments.
  final Map<String, String>? namedArgs;
}

/// A class that represents a text key with arguments.
class TextKeyWithArgs extends _TextKeyWithArgsBase {
  /// A class that represents a text key with arguments.
  const TextKeyWithArgs({
    required super.textKey,
    super.args,
    super.namedArgs,
  });
}

/// A class that represents a text key with arguments.
class PluralTextKeyWithArgs extends _TextKeyWithArgsBase {
  /// A class that represents a text key with arguments.
  const PluralTextKeyWithArgs({
    required this.value,
    required super.textKey,
    super.args,
    super.namedArgs,
  });

  /// The value.
  final num value;
}
