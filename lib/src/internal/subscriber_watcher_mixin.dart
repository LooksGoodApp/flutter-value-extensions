import 'package:flutter/foundation.dart';
import 'package:value_extensions/src/internal/subscriptions_watcher_notifier_mixin.dart';
import 'package:value_extensions/value_extensions.dart';

/// Mixin that allows efficiently deriving a [ValueNotifier] from a
/// base [Listenable].
///
/// The subscription is active only when the class that
/// mixes [SubscriberWatcherMixin] in itself has listeners. It is cancelled when
/// it looses the last subscriber, thus automatically managing the relationship
/// between [Listenable]s
mixin SubscriberWatcherMixin<A>
    on ValueNotifier<A>, SubscriptionsWatcherNotifierMixin {
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
  A get value {
    if (!hasListeners) _updateValue();
    return currentValue;
  }

  A get currentValue => super.value;
}
