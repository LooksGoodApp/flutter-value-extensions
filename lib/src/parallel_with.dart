part of value_extensions;

class Pair<A, B> {
  final A first;
  final B second;
  const Pair._(this.first, this.second);
}

/// Allows to avoid nesting by paralleling two [ValueListenable]s. This is a
/// wrapper over the [combineLatest] extensions.
///
/// Performance note – this extensions is often used inside UI, and its result
/// must be disposed as any other [ValueListenable].
extension Parallel<A> on ValueListenable<A> {
  /// Allows to avoid nesting by paralleling two [ValueListenable]s. This is a
  /// wrapper over the [combineLatest] extensions.
  ///
  /// Performance note – this extensions is often used inside UI, and its result
  /// must be disposed as any other [ValueListenable].
  ValueListenable<Pair<A, B>> parallelWith<B>(ValueListenable<B> other) =>
      combineLatest(
        other,
        (first, B second) => Pair._(first, second),
      );
}

extension BindParallel<A, B> on ValueListenable<Pair<A, B>> {
  Widget bind(Widget Function(A first, B second) to) =>
      ValueListenableBuilder<Pair<A, B>>(
        valueListenable: this,
        builder: (_, value, __) => to(value.first, value.second),
      );
}
