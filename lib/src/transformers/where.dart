import 'package:flutter/foundation.dart';

import 'package:value_extensions/src/internal/subscriber_notifier.dart';
import 'package:value_extensions/src/typedefs.dart';

class _FilteredValueNotifier<A> extends SubscriberNotifier<A> {
  @override
  final ValueListenable<A> listenable;
  final Predicate<A> _predicate;

  _FilteredValueNotifier(this.listenable, this._predicate)
      : super(listenable.value);

  @override
  A computeValue() {
    final sourceValue = listenable.value;

    return _predicate(sourceValue) ? sourceValue : currentValue;
  }
}

/// {@template where.extension}
/// Creates a new [ValueListenable] that filters base
/// [ValueListenable]'s values using the give predicate.
///
/// Note – initial listenable's value is assigned without using the predicate.
/// {@endtemplate}
extension ValueListenableWhereExtension<A> on ValueListenable<A> {
  /// {@macro where.extension}
  ValueListenable<A> where(Predicate<A> predicate) =>
      _FilteredValueNotifier(this, predicate);
}
