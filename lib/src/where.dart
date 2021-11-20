part of value_extensions;

class _FilteredValueNotifier<T>
    extends SingleSubscriptionWatcherNotifier<T, T> {
  final ValueListenable<T> baseNotifier;
  final bool Function(T value) _filter;

  _FilteredValueNotifier(this.baseNotifier, this._filter)
      : super(baseNotifier.value);

  void updateValue() {
    final baseValue = baseNotifier.value;
    if (_filter(baseValue)) value = baseValue;
  }
}

/// Creates a new [ValueListenable] that filters base notifiers' values with
/// the given filter function.
///
/// Note – new notifiers' value is assigned without using the filter function
/// to avoid nulls.
extension WhereValueListenableExtension<T> on ValueListenable<T> {
  /// Creates a new [ValueNotifier] that filters base notifiers' values with
  /// the given filter function.
  ///
  /// Note – new notifiers' value is assigned without using the filter function
  /// to avoid nulls.
  ValueListenable<T> where(bool Function(T value) filter) =>
      _FilteredValueNotifier(this, filter);
}
