part of value_extensions;

extension Set<T> on ValueNotifier<T> {
  /// Convenience setter, used to reduce verbosity.
  ///
  /// Consider this example:
  ///
  /// ```dart
  /// /// Traditional
  /// someNotifier.value = someNotifier.value * 10;
  ///
  /// /// Extension
  /// someNotifier.set((current) => current * 10);
  /// ```
  ///
  ///
  void set(T Function(T current) transform) => value = transform(value);
}
