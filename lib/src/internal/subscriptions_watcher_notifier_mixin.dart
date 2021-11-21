import 'package:flutter/material.dart';

mixin SubscriptionsWatcherNotifierMixin<A> on ValueNotifier<A> {
  @override
  void addListener(VoidCallback listener) {
    if (!hasListeners) onListened();
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) onForgotten();
  }

  void onListened() {}

  void onForgotten() {}
}
