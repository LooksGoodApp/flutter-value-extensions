import 'package:flutter/foundation.dart';
import 'package:value_extensions/src/internal/subscriptions_watcher_notifier_mixin.dart';
import 'package:value_extensions/value_extensions.dart';

mixin SubscriberWatcherMixin<A> on SubscriptionsWatcherNotifierMixin<A> {
  A computeValue();
  Listenable get listenable;

  Listenable? _cache;
  Listenable get _cachedListenable => _cache ??= listenable;

  void _updateValue() => set(computeValue());

  @override
  void onListened() {
    super.onListened();
    _updateValue();
    _cachedListenable.addListener(_updateValue);
  }

  @override
  void onForgotten() {
    super.onForgotten();
    _cachedListenable.removeListener(_updateValue);
  }

  @override
  A get value => hasListeners ? super.value : computeValue();

  A get currentValue => super.value;
}
