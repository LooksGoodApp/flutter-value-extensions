import 'package:flutter/foundation.dart';

import 'package:value_extensions/src/internal/subscriber_notifier.dart';
import 'package:value_extensions/src/typedefs.dart';

class _MappedValueNotifier<A, B> extends SubscriberNotifier<B> {
  @override
  final ValueListenable<A> listenable;
  final UnaryFunction<A, B> _transform;

  _MappedValueNotifier(this.listenable, this._transform)
      : super(_transform(listenable.value));

  @override
  B computeValue() => _transform(listenable.value);
}

/// {@template map.extension}
/// Creates a new [ValueListenable] using the [transform] function, recomputing
/// its value every time the base Listenable changes, applying the [transform]
/// function to the new value.
/// {@endtemplate}
extension ValueListenableMapExtension<A> on ValueListenable<A> {
  /// {@macro map.extension}
  ValueListenable<B> map<B>(
    UnaryFunction<A, B> transform,
  ) =>
      _MappedValueNotifier(this, transform);
}
