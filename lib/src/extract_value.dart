part of value_extensions;

class _ExtractedValueNotifier<T> extends WatcherNotifier<T> {
  StreamSubscription<T>? _streamSubscription;
  final Stream<T> _stream;

  _ExtractedValueNotifier(this._stream, T initialValue) : super(initialValue);

  void _subscribe() {
    _streamSubscription = _stream.listen(set);
  }

  void _unsubscribe() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  @override
  void onListened() {
    super.onListened();
    if (_streamSubscription == null) _subscribe();
  }

  @override
  void onForgotten() {
    super.onForgotten();
    _unsubscribe();
  }

  @override
  T get value {
    if (_streamSubscription == null) {
      _subscribe();
      Future(_unsubscribe);
    }
    return super.value;
  }
}

extension ExtractValueStreamExtension<T> on Stream<T> {
  ValueListenable<T> extractValue({required T initial}) =>
      _ExtractedValueNotifier(this, initial);
}
