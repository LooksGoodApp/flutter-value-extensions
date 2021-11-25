import 'package:flutter/material.dart';

/// Mixin that watches adding and removal of the listeners that allows to
/// execute callbacks when the [ChangeNotifier] obtains the first listener or
/// loses the last one.
mixin SubscriptionsWatcherNotifierMixin on ChangeNotifier {
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
