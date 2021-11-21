import 'package:flutter/foundation.dart';

import 'package:value_extensions/src/internal/watcher_notifier_mixin.dart';
import 'package:value_extensions/src/types.dart';
import 'package:value_extensions/src/utility/setters.dart';
import 'package:value_extensions/src/utility/subscribe.dart';

class _FlatMappedValueNotifier<A, B> extends ValueNotifier<B>
    with WatcherNotifierMixin<B> {
  final ValueListenable<A> _baseNotifier;
  final FlatMapTransform<A, B> _transform;

  Subscription? _baseNotifierSubscription;
  Subscription? _currentSourceSubscription;

  _FlatMappedValueNotifier(this._baseNotifier, this._transform)
      : super(_transform(_baseNotifier.value).value);

  ValueListenable<B> _currentNotifier() => _transform(_baseNotifier.value);

  void _subscribeCurrent() {
    final currentNotifier = _currentNotifier();
    set(currentNotifier.value);
    _currentSourceSubscription = currentNotifier.subscribe(set);
  }

  @override
  void onListened() {
    super.onListened();
    _subscribeCurrent();
    _baseNotifierSubscription = _baseNotifier.subscribe((_) {
      _currentSourceSubscription?.cancel();
      _subscribeCurrent();
    });
  }

  @override
  void onForgotten() {
    super.onForgotten();
    _currentSourceSubscription?.cancel();
    _baseNotifierSubscription?.cancel();
  }

  @override
  B get value => hasListeners ? super.value : _currentNotifier().value;
}

/// Creates a new [ValueListenable] from the base notifier,
/// using transform function.
///
/// Works like [map] but transform function must return another
/// [ValueListenable] instead of regular value.
extension ValueListenableFlatMapExtension<A> on ValueListenable<A> {
  /// Creates a new [ValueListenable] from the base notifier,
  /// using transform function.
  ///
  /// Works like [map] but transform function must return another
  /// [ValueListenable] instead of regular value.
  ValueListenable<B> flatMap<B>(FlatMapTransform<A, B> transform) =>
      _FlatMappedValueNotifier(this, transform);
}
