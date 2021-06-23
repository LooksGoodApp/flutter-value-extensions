part of value_extensions;

class _FilteredValueNotifier<T> extends ValueNotifier<T> {
  final ValueNotifier<T> _baseNotifier;
  final bool Function(T value) _filter;
  late final Subscription _whereSubscription;

  _FilteredValueNotifier(this._baseNotifier, this._filter)
      : super(_baseNotifier.value) {
    _whereSubscription = _baseNotifier.subscribe(_listener);
  }

  void _listener(T baseValue) {
    if (_filter(baseValue)) {
      value = baseValue;
    }
  }

  @override
  void dispose() {
    _whereSubscription.cancel();
    super.dispose();
  }
}

extension Where<T> on ValueNotifier<T> {
  /// Creates a new [ValueNotifier] that filters base notifiers' values with
  /// the given filter function.
  /// 
  /// Note – new notifiers' value is assigned without using the filter function
  /// to avoid nulls.
  _FilteredValueNotifier<T> where(bool Function(T value) filter) =>
      _FilteredValueNotifier(this, filter);
}

