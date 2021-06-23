part of value_extensions;

typedef _MapTransform<BaseType, DerivedType> = DerivedType Function(
    BaseType value);

class _MappedValueNotifier<BaseType, DerivedType>
    extends ValueNotifier<DerivedType> {
  final ValueNotifier<BaseType> _baseNotifier;
  final _MapTransform<BaseType, DerivedType> _transform;
  late final Subscription _mapSubscription;

  _MappedValueNotifier(this._baseNotifier, this._transform)
      : super(_transform(_baseNotifier.value)) {
    _mapSubscription = _baseNotifier.subscribe(_listener);
  }

  void _listener(BaseType baseValue) => set((_) => _transform(baseValue));

  @override
  void dispose() {
    _mapSubscription.cancel();
    super.dispose();
  }
}

extension Map<BaseType> on ValueNotifier<BaseType> {
  /// Creates a new [ValueNotifier] using the [transform] function
  _MappedValueNotifier<BaseType, DerivedType> map<DerivedType>(
          _MapTransform<BaseType, DerivedType> transform) =>
      _MappedValueNotifier(this, transform);
}
