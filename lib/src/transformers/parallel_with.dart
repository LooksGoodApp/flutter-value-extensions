import 'package:flutter/foundation.dart';

import 'package:value_extensions/src/types.dart';
import 'package:value_extensions/src/transformers/combine_latest.dart';

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
