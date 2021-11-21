part of value_extensions;

class _CombineLatestValueNotifier<A, B, C> extends SubscriberNotifier<C> {
  final ValueListenable<A> _first;
  final ValueListenable<B> _second;
  final BinaryFunction<A, B, C> _transform;

  _CombineLatestValueNotifier(this._first, this._second, this._transform)
      : super(_transform(_first.value, _second.value));

  C computeValue() => _transform(_first.value, _second.value);

  Listenable get listenable => Listenable.merge([_first, _second]);
}

/// Creates a new [ValueListenable] from the given two, using the given
/// transform function, updating its value every time any of the two
/// base notifiers change.
extension ValueListenableCombineLatestExtension<A> on ValueListenable<A> {
  /// Creates a new [ValueListenable] from the given two, using the given
  /// transform function, updating its value every time any of the two
  /// base notifiers change.
  ValueListenable<C> combineLatest<B, C>(
    ValueListenable<B> other,
    BinaryFunction<A, B, C> transform,
  ) =>
      _CombineLatestValueNotifier(this, other, transform);
}