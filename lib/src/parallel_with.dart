part of value_extensions;

class _Pair<FirstType, SecondType> {
  final FirstType first;
  final SecondType second;
  _Pair(this.first, this.second);
}

extension Parallel<FirstType> on ValueNotifier<FirstType> {
  /// Allows to avoid nesting by paralleling two [ValueNotifiers]. This is a 
  /// wrapper over the [ValueNotifier.combineLatest] extensions.
  /// 
  /// Performance note – this extensions is often used inside UI, and its result
  /// must be disposed as any other [ValueNotifier]. To avoid memory leaks,
  /// use [DisposableBuilder] when using this extension.
  ValueNotifier<_Pair<FirstType, SecondType>> parallelWith<SecondType>(
          ValueNotifier<SecondType> other) =>
      this.combineLatest(
        other,
        (FirstType first, SecondType second) => _Pair(first, second),
      );
}
