import 'package:flutter/foundation.dart';
import 'package:value_extensions/src/internal/watcher_notifier.dart';
import 'package:value_extensions/value_extensions.dart';

abstract class SingleSubscriptionWatcherNotifier<B, T>
    extends WatcherNotifier<T> {
  late final Subscription subscription;

  SingleSubscriptionWatcherNotifier(T value) : super(value) {
    subscription = baseNotifier.subscribe((_) => updateValue());
  }

  void updateValue();
  ValueListenable<B> get baseNotifier;

  @override
  void onListened() {
    super.onListened();
    updateValue();
    subscription.pause();
  }

  @override
  void onForgotten() {
    super.onForgotten();
    subscription.pause();
  }

  @override
  T get value {
    if (!hasListeners) updateValue();
    return super.value;
  }
}
