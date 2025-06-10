/// Base text key object for the translation keys of Novade Lite.
abstract class TextKeyBase {
  /// Base text key object for the translation keys of Novade Lite.
  const TextKeyBase();

  /// Returns the key for the translation library.
  String toKeyString() => '';

  @override
  String toString() => 'TextKey(${toKeyString()})';
}

/// A text key that can be translated.
///
/// The key doesn't have any children.
abstract class TextKey extends TextKeyBase {
  /// A text key that can be translated.
  ///
  /// The key doesn't have any children.
  const TextKey() : super();
}

/// A text key that cannot be translated.
///
/// It has children.
abstract class TextKeyNode extends TextKeyBase {
  /// A text key that cannot be translated.
  ///
  /// It has children.
  const TextKeyNode() : super();

  /// Returns the child key from the key string.
  TextKeyBase operator [](String key) {
    assert(false, 'key "$key" does not exist in type $this');
    return this;
  }
}

/// A text key that can use the plural method from the easy localization
/// library.
abstract class TextKeyPlural extends TextKeyNode {
  /// A text key that can use the plural method from the easy localization
  /// library.
  const TextKeyPlural() : super();
}
