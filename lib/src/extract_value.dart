part of value_extensions;

class _ExtractedValueNotifier<T> extends ValueNotifier<T> {
  late final StreamSubscription<T> _streamSubscription;

  _ExtractedValueNotifier(Stream<T> stream, T initialValue)
      : super(initialValue) {
    _streamSubscription = stream.listen(_listener);
  }

  void _listener(T value) => set(value);

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}

extension ExtractValue<T> on Stream<T> {
  _ExtractedValueNotifier<T> extractValue({required T initial}) =>
      _ExtractedValueNotifier(this, initial);
}
