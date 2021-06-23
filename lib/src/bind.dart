part of value_extensions;

extension Bind<T> on ValueNotifier<T> {
  /// Binds this [ValueNotifier] variable to the given Widget.
  ///
  /// This is a wrapper for the [ValueListenableBuilder];
  Widget bind(Widget Function(T value) to) => ValueListenableBuilder<T>(
      valueListenable: this, builder: (_, value, __) => to(value));
}
