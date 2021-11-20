part of value_extensions;

class _FilteredValueNotifier<T> extends WatcherNotifier<T> {
  final ValueListenable<T> _baseNotifier;
  final bool Function(T value) _filter;
  late final Subscription _whereSubscription;

  _FilteredValueNotifier(this._baseNotifier, this._filter)
      : super(_baseNotifier.value) {
    _whereSubscription = _baseNotifier.subscribe(_listener, subscribe: false);
  }

  void _considerSetting() {
    final baseValue = _baseNotifier.value;
    if (_filter(baseValue)) super.value = baseValue;
  }

  void _listener(T _) {
    _considerSetting();
  }

  @override
  void onListened() {
    super.onListened();
    _considerSetting();
    _whereSubscription.pause();
  }

  @override
  void onForgotten() {
    super.onForgotten();
    _whereSubscription.pause();
  }

  @override
  T get value {
    if (!hasListeners) _considerSetting();
    return super.value;
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
