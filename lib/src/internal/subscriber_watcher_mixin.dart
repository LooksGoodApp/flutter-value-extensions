import 'package:flutter/foundation.dart';
import 'package:value_extensions/src/internal/watcher_notifier.dart';
import 'package:value_extensions/value_extensions.dart';

abstract class SubscriberWatcherNotifier<T> extends WatcherNotifier<T> {
  SubscriberWatcherNotifier(T value) : super(value);

  T computeValue();
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
  T get value {
    if (!hasListeners) _updateValue();
    return super.value;
  }
}
