import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:value_extensions/src/types.dart';

/// Binds this [ValueListenable] variable to the given Widget.
///
/// This is a wrapper for the [ValueListenableBuilder];
extension ValueListenableBindExtension<A> on ValueListenable<A> {
  /// Binds this [ValueListenable] variable to the given Widget.
  ///
  /// This is a wrapper for the [ValueListenableBuilder];
  Widget bind(UnaryWidgetBuilder<A> builder) => ValueListenableBuilder<A>(
        valueListenable: this,
        builder: (_, value, __) => builder(value),
      );
}

extension ValueListenableBindParallelExtension<A, B>
    on ValueListenable<Pair<A, B>> {
  Widget bind(BinaryWidgetBuilder<A, B> to) =>
      ValueListenableBuilder<Pair<A, B>>(
        valueListenable: this,
        builder: (_, value, __) => to(value.first, value.second),
      );
}
