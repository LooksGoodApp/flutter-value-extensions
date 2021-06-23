part of value_extensions;

typedef _FlatMapTransform<BaseType, DerivedType> = ValueNotifier<DerivedType>
    Function(BaseType value);

class _FlatMappedValueNotifier<BaseType, DerivedType>
    extends ValueNotifier<DerivedType> {
  final ValueNotifier<BaseType> _baseNotifier;
  final _FlatMapTransform<BaseType, DerivedType> _transform;
  late final Subscription _flatMapSubscription;

  Subscription? _currentSubscription;
  ValueNotifier<DerivedType>? _currentValue;

  _FlatMappedValueNotifier(this._baseNotifier, this._transform)
      : super(_transform(_baseNotifier.value).value) {
    _flatMapSubscription = _baseNotifier.subscribe(_listener);
  }

  void _listener(BaseType baseValue) {
    _currentValue = _transform(baseValue);
    set((_) => _currentValue!.value);
    _currentSubscription?.cancel();
    _currentSubscription =
        _currentValue!.subscribe((value) => set((_) => value));
  }

  @override
  void dispose() {
    _currentSubscription?.cancel();
    _flatMapSubscription.cancel();
    super.dispose();
  }
}

extension FlatMap<BaseType> on ValueNotifier<BaseType> {
  /// Creates a new [ValueNotifier] from the base notifier,
  /// using transform function.
  /// 
  /// Works like [ValueNotifier.map] but transform function must return another 
  /// [ValueNotifier] instead of regular value.
  _FlatMappedValueNotifier<BaseType, DerivedType> flatMap<DerivedType>(
          _FlatMapTransform<BaseType, DerivedType> transform) =>
      _FlatMappedValueNotifier(this, transform);
}
