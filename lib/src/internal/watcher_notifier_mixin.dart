import 'package:flutter/material.dart';

mixin WatcherNotifierMixin<T> on ValueNotifier<T> {
  final _listenersSet = <VoidCallback>{};

  @override
  void addListener(VoidCallback listener) {
    if (_listenersSet.isEmpty) onListened();
    _listenersSet.add(listener);
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    if (_listenersSet.remove(listener) && _listenersSet.isEmpty) onForgotten();
    super.removeListener(listener);
  }

  void onListened() {}

  void onForgotten() {}

  bool get hasListeners => _listenersSet.isNotEmpty;
}
