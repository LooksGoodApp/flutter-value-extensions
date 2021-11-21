part of value_extensions;

class _ExtractedValueNotifier<A> extends ValueNotifier<A>
    with WatcherNotifierMixin<A> {
  StreamSubscription<A>? _streamSubscription;
  var _streamDone = false;
  var _subscribedOnDone = false;

  final Stream<A> _stream;

  _ExtractedValueNotifier(this._stream, A initialValue) : super(initialValue);

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
  A get value {
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

extension ExtractValueStreamExtension<A> on Stream<A> {
  ValueListenable<A> extractValue({required A initial}) =>
      _ExtractedValueNotifier(this, initial);
}
