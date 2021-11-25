import 'package:flutter/foundation.dart';

import 'package:value_extensions/src/internal/subscriptions_watcher_notifier_mixin.dart';
import 'package:value_extensions/src/typedefs.dart';
import 'package:value_extensions/src/utility/setters.dart';
import 'package:value_extensions/src/utility/subscribe.dart';

class _FlatMappedValueNotifier<A, B> extends ValueNotifier<B>
    with SubscriptionsWatcherNotifierMixin {
  final ValueListenable<A> _baseNotifier;
  final FlatMapTransform<A, B> _transform;

  _FlatMappedValueNotifier(this._baseNotifier, this._transform)
      : super(_transform(_baseNotifier.value).value);

  Subscription? _baseNotifierSubscription;
  Subscription? _currentSourceSubscription;

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

/// {@template flat_map.extension}
/// Creates a new [ValueListenable] from the base notifier,
/// using transform function.
///
/// Works like [map] but transform function must return another
/// [ValueListenable] instead of regular value, recomputing its value every time
/// when the [ValueListenable] on which the [flatMap] was called changes.
/// {@endtemplate}
extension ValueListenableFlatMapExtension<A> on ValueListenable<A> {
  /// {@macro flat_map.extension}
  ValueListenable<B> flatMap<B>(FlatMapTransform<A, B> transform) =>
      _FlatMappedValueNotifier(this, transform);
}
