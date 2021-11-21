part of value_extensions;

class _FilteredValueNotifier<A> extends SubscriberNotifier<A> {
  final ValueListenable<A> listenable;
  final Predicate<A> _predicate;

  _FilteredValueNotifier(this.listenable, this._predicate)
      : super(listenable.value);

  A computeValue() {
    final sourceValue = listenable.value;

    return _predicate(sourceValue) ? sourceValue : super.value;
  }
}

/// Creates a new [ValueListenable] that filters base notifiers' values with
/// the given filter function.
///
/// Note – new notifiers' value is assigned without using the filter function
/// to avoid nulls.
extension ValueListenableWhereExtension<A> on ValueListenable<A> {
  /// Creates a new [ValueListenable] that filters base notifiers' values with
  /// the given filter function.
  ///
  /// Note – new notifiers' value is assigned without using the filter function
  /// to avoid nulls.
  ValueListenable<A> where(Predicate<A> predicate) =>
      _FilteredValueNotifier(this, predicate);
}