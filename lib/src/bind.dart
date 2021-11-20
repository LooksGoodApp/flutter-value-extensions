part of value_extensions;

/// Binds this [ValueListenable] variable to the given Widget.
///
/// This is a wrapper for the [ValueListenableBuilder];
extension BindValueListenableExtension<T> on ValueListenable<T> {
  /// Binds this [ValueListenable] variable to the given Widget.
  ///
  /// This is a wrapper for the [ValueListenableBuilder];
  Widget bind(Widget Function(T value) to) => ValueListenableBuilder<T>(
        valueListenable: this,
        builder: (_, value, __) => to(value),
      );
}
