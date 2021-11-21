import 'package:flutter/material.dart';

import 'package:value_extensions/src/typedefs.dart';

/// Convenience setter, used to reduce verbosity.
///
/// Consider this example:
///
/// ```dart
/// /// Traditional
/// someNotifier.value = someNotifier.value * 10;
///
/// /// Extension
/// someNotifier.set((current) => current * 10);
/// ```
///
///
extension ValueNotifierSettersExtension<A> on ValueNotifier<A> {
  /// Convenience setter, used to reduce verbosity.
  ///
  /// Consider this example:
  ///
  /// ```dart
  /// /// Traditional
  /// someNotifier.value = someNotifier.value * 10;
  ///
  /// /// Extension
  /// someNotifier.set((current) => current * 10);
  /// ```
  ///
  ///
  void set(A newValue) => value = newValue;
  void update(Endomorphic<A> update) => set(update(value));
}
