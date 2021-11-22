import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:value_extensions/src/transformers/parallel_with.dart';

import 'package:value_extensions/src/typedefs.dart';

/// {@template bind.extension.regular}
/// Binds this [ValueListenable] variable to the given Widget.
///
/// This is a wrapper for the [ValueListenableBuilder].
/// {@endtemplate}
extension ValueListenableBindExtension<A> on ValueListenable<A> {
  /// {@macro bind.extension.regular}
  Widget bind(UnaryWidgetBuilder<A> builder) => ValueListenableBuilder<A>(
        valueListenable: this,
        builder: (_, value, __) => builder(value),
      );
}

/// {@template bind.extension.pair}
/// Works the same as the [ValueListenableBindExtension], but destructures its
/// arguments in the builder function.
/// {@endtemplate}
extension ValueListenableBindParallelExtension<A, B>
    on ValueListenable<Pair<A, B>> {
  /// {@macro bind.extension.pair}
  Widget bind(BinaryWidgetBuilder<A, B> to) =>
      ValueListenableBuilder<Pair<A, B>>(
        valueListenable: this,
        builder: (_, value, __) => to(value.first, value.second),
      );
}
