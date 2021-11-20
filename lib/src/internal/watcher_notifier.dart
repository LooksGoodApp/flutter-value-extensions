import 'package:flutter/material.dart';

abstract class WatcherNotifier<T> extends ValueNotifier<T> {
  var _listeners = 0;

  WatcherNotifier(T value) : super(value);

  @override
  void addListener(VoidCallback listener) {
    if (_listeners++ == 0) onListened();
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    if (--_listeners == 0) onForgotten();
    super.removeListener(listener);
  }

  void onListened() {}

  void onForgotten() {}

  bool get hasListeners => _listeners != 0;
}
