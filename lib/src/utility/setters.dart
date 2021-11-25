import 'package:flutter/material.dart';

import 'package:value_extensions/src/typedefs.dart';

/// Pair of setters used to reduce verbosity and improve ease of use.
extension ValueNotifierSettersExtension<A> on ValueNotifier<A> {
  /// Method-setter that is identical to the [value] setter.
  ///
  /// ```dart
  /// /// Traditional
  /// someNotifier.value = 100;
  ///
  /// /// Extension
  /// someNotifier.set(100);
  /// ```
  ///
  ///
  void set(A newValue) => value = newValue;

  /// Method-setter that is useful when the new value of the [ValueNotifiers]
  /// depends on its previous one.
  ///
  /// ```dart
  /// int timesTwo(int x) => x * 2;
  ///
  /// /// Traditional
  /// someNotifier.value = timesTwo(someNotifier.value);
  ///
  /// /// Extension
  /// someNotifier.update(timesTwo);
  /// ```
  void update(Endomorphic<A> update) => set(update(value));
}
