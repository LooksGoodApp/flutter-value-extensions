import 'package:flutter/foundation.dart';

import 'package:value_extensions/src/internal/subscriber_notifier.dart';
import 'package:value_extensions/src/types.dart';

class _MappedValueNotifier<A, B> extends SubscriberNotifier<B> {
  final ValueListenable<A> listenable;
  final UnaryFunction<A, B> _transform;

  _MappedValueNotifier(this.listenable, this._transform)
      : super(_transform(listenable.value));

  B computeValue() => _transform(listenable.value);
}

/// Creates a new [ValueListenable] using the [transform] function
extension ValueListenableMapExtension<A> on ValueListenable<A> {
  /// Creates a new [ValueListenable] using the [transform] function
  ValueListenable<B> map<B>(
    UnaryFunction<A, B> transform,
  ) =>
      _MappedValueNotifier(this, transform);
}
