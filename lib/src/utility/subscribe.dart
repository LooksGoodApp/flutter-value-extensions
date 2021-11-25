import 'package:flutter/foundation.dart';

import 'package:value_extensions/src/typedefs.dart';

abstract class Subscription {
  void cancel();
  void pause();

  bool get isCanceled;
  bool get isPaused;
  bool get isActive;
}

class _Subscription<A> extends Subscription {
  final ValueListenable<A> _listenable;
  final VoidCallback _listener;
  bool _isCanceled = false;
  bool _isPaused;
  bool _isActive;

  _Subscription(
    this._listenable,
    this._listener, {
    required bool subscribe,
  })  : _isPaused = !subscribe,
        _isActive = subscribe {
    if (subscribe) _subscribe();
  }

  void _subscribe() {
    _listenable.addListener(_listener);
  }

  void _unsubscribe() {
    _listenable.removeListener(_listener);
  }

  void _ifNotCanceled(VoidCallback body) {
    if (!_isCanceled) body();
  }

  @override
  void cancel() => _ifNotCanceled(() {
        _unsubscribe();
        _isCanceled = true;
        _isActive = false;
      });

  @override
  void pause() => _ifNotCanceled(() {
        if (_isPaused) {
          _isPaused = false;
          _isActive = true;
          _subscribe();
        } else {
          _isPaused = true;
          _isActive = false;
          _unsubscribe();
        }
      });
  @override
  bool get isCanceled => _isCanceled;
  @override
  bool get isPaused => _isPaused;
  @override
  bool get isActive => _isActive;
}

/// {@template subscribe.extension}
/// Works as [ValueListenable.addListener], but returns a cancelable
/// [Subscription] object that can be paused, canceled and resumed.
///
/// To resume a subscription after the [pause()] method was invoked it must
/// be invoked a second time.
/// {@endtemplate}
extension ValueListenableSubscribeExtensions<A> on ValueListenable<A> {
  /// {@macro subscribe.extension}
  _Subscription<A> subscribe(
    UnaryVoidCallback<A> listener, {
    bool subscribe = true,
  }) =>
      _Subscription(this, () => listener(value), subscribe: subscribe);
}
