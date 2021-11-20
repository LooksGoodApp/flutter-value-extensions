part of value_extensions;

typedef BinaryTransform<A, B, C> = C Function(A first, B second);

class _CombineLatestValueNotifier<A, B, C>
    extends SubscriberWatcherNotifier<C> {
  final ValueListenable<A> _first;
  final ValueListenable<B> _second;
  final BinaryTransform<A, B, C> _transform;

  _CombineLatestValueNotifier(this._first, this._second, this._transform)
      : super(_transform(_first.value, _second.value));

  C computeValue() => _transform(_first.value, _second.value);

  Listenable get listenable => Listenable.merge([_first, _second]);
}

/// Creates a new [ValueListenable] from the given two, using the given
/// transform function, updating its value every time any of the two
/// base notifiers change.
extension CombineLatest<A> on ValueListenable<A> {
  /// Creates a new [ValueListenable] from the given two, using the given
  /// transform function, updating its value every time any of the two
  /// base notifiers change.
  ValueListenable<C> combineLatest<B, C>(
    ValueListenable<B> other,
    BinaryTransform<A, B, C> transform,
  ) =>
      _CombineLatestValueNotifier(this, other, transform);
}
