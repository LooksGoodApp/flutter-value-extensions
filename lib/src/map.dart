part of value_extensions;

class _MappedValueNotifier<A, B> extends SubscriberWatcherNotifier<B> {
  final ValueListenable<A> listenable;
  final B Function(A value) _transform;

  _MappedValueNotifier(this.listenable, this._transform)
      : super(_transform(listenable.value));

  B computeValue() => _transform(listenable.value);
}

/// Creates a new [ValueListenable] using the [transform] function
extension MapValueListenableExtensions<BaseType> on ValueListenable<BaseType> {
  /// Creates a new [ValueListenable] using the [transform] function
  ValueListenable<DerivedType> map<DerivedType>(
    DerivedType Function(BaseType value) transform,
  ) =>
      _MappedValueNotifier(this, transform);
}
