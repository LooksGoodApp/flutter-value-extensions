part of value_extensions;

class _ExtractedValueNotifier<T> extends ValueNotifier<T>
    with WatcherNotifierMixin<T> {
  StreamSubscription<T>? _streamSubscription;
  var _streamDone = false;
  var _subscribedOnDone = false;

  final Stream<T> _stream;

  _ExtractedValueNotifier(this._stream, T initialValue) : super(initialValue);

  void _subscribe() {
    _streamSubscription = _stream.listen(set, onDone: () => _streamDone = true);
  }

  void _unsubscribe() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  @override
  void onListened() {
    super.onListened();
    if (_streamSubscription == null && !_streamDone) _subscribe();
  }

  @override
  void onForgotten() {
    super.onForgotten();
    _unsubscribe();
  }

  @override
  T get value {
    if (_streamSubscription == null && !_subscribedOnDone) {
      _subscribe();
      Future(() {
        _unsubscribe();
        if (_streamDone) _subscribedOnDone = true;
      });
    }
    return super.value;
  }
}

extension ExtractValueStreamExtension<T> on Stream<T> {
  ValueListenable<T> extractValue({required T initial}) =>
      _ExtractedValueNotifier(this, initial);
}
