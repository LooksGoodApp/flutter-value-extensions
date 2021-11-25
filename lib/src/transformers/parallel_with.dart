import 'package:flutter/foundation.dart';

import 'package:value_extensions/src/transformers/combine_latest.dart';

class Pair<A, B> {
  final A first;
  final B second;

  const Pair._(this.first, this.second);
}

/// {@template parallel_with.extension}
/// Allows to avoid nesting by paralleling two [ValueListenable]s. This is a
/// wrapper over the [combineLatest] extensions.
///
/// The bind method on the obtained [ValueListenable] automatically destructures
/// its only argument.
/// {@endtemplate}
extension ValueListenableParallelExtension<A> on ValueListenable<A> {
  /// {@macro parallel_with.extension}
  ValueListenable<Pair<A, B>> parallelWith<B>(ValueListenable<B> other) =>
      combineLatest<B, Pair<A, B>>(
        other,
        (first, second) => Pair._(first, second),
      );
}
