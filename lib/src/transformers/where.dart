part of value_extensions;

class _FilteredValueNotifier<T> extends SubscriberNotifier<T> {
  final ValueListenable<T> listenable;
  final bool Function(T value) _filter;

  _FilteredValueNotifier(this.listenable, this._filter)
      : super(listenable.value);

  T computeValue() {
    final baseValue = listenable.value;

    return _filter(baseValue) ? baseValue : super.value;
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
