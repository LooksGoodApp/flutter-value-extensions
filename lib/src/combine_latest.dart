part of value_extensions;

typedef _LatestTransform<FirstType, SecondType, DerivedType> = DerivedType
    Function(FirstType first, SecondType second);

class _CombineLatestValueNotifier<FirstType, SecondType, DerivedType>
    extends ValueNotifier<DerivedType> {
  final ValueNotifier<FirstType> _first;
  final ValueNotifier<SecondType> _second;
  final _LatestTransform<FirstType, SecondType, DerivedType> _transform;
  late final Subscription _firstSubscription;
  late final Subscription _secondSubscription;

  _CombineLatestValueNotifier(this._first, this._second, this._transform)
      : super(_transform(_first.value, _second.value)) {
    _firstSubscription = _first.subscribe(
      (firstValue) => _listener(firstValue, _second.value),
    );
    _secondSubscription = _second.subscribe(
      (secondValue) => _listener(_first.value, secondValue),
    );
  }

  void _listener(FirstType first, SecondType second) =>
      set((_) => _transform(first, second));

  @override
  void dispose() {
    _firstSubscription.cancel();
    _secondSubscription.cancel();
    super.dispose();
  }
}

/// Creates a new [ValueNotifier] from the given two, using the given
/// transform function, updating its value every time any of the two
/// base notifiers change.
extension CombineLatest<FirstType> on ValueNotifier<FirstType> {
  /// Creates a new [ValueNotifier] from the given two, using the given
  /// transform function, updating its value every time any of the two
  /// base notifiers change.
  _CombineLatestValueNotifier<FirstType, SecondType, DerivedType>
      combineLatest<SecondType, DerivedType>(ValueNotifier<SecondType> other,
              _LatestTransform<FirstType, SecondType, DerivedType> transform) =>
          _CombineLatestValueNotifier(this, other, transform);
}
