import 'package:flutter/foundation.dart';

import 'package:value_extensions/src/transformers/combine_latest.dart';

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
extension ValueListenableParallelExtension<A> on ValueListenable<A> {
  /// Allows to avoid nesting by paralleling two [ValueListenable]s. This is a
  /// wrapper over the [combineLatest] extensions.
  ///
  /// Performance note – this extensions is often used inside UI, and its result
  /// must be disposed as any other [ValueListenable].
  ValueListenable<Pair<A, B>> parallelWith<B>(ValueListenable<B> other) =>
      combineLatest(
        other,
        // ignore: avoid_types_on_closure_parameters
        (first, B second) => Pair._(first, second),
      );
}
