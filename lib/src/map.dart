part of value_extensions;

class _MappedValueNotifier<BaseType, DerivedType>
    extends SingleSubscriptionWatcherNotifier<BaseType, DerivedType> {
  final ValueListenable<BaseType> baseNotifier;
  final DerivedType Function(BaseType value) _transform;

  _MappedValueNotifier(this.baseNotifier, this._transform)
      : super(_transform(baseNotifier.value));

  void updateValue() => set(_transform(baseNotifier.value));
}

/// Creates a new [ValueListenable] using the [transform] function
extension MapValueListenableExtensions<BaseType> on ValueListenable<BaseType> {
  /// Creates a new [ValueListenable] using the [transform] function
  ValueListenable<DerivedType> map<DerivedType>(
    DerivedType Function(BaseType value) transform,
  ) =>
      _MappedValueNotifier(this, transform);
}
