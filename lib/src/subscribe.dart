part of value_extensions;

/// [ValueNotifier] [Subscription] object that can be canceled.
abstract class Subscription {
  void cancel();
  void pause();

  bool get isCanceled;
  bool get isPaused;
  bool get isActive;
}

class _Subscription<T> extends Subscription {
  final ValueListenable _listenable;
  final void Function() _listener;
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

  void cancel() => _ifNotCanceled(() {
        _unsubscribe();
        _isCanceled = true;
        _isActive = false;
      });

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
  bool get isCanceled => _isCanceled;
  bool get isPaused => _isPaused;
  bool get isActive => _isActive;
}

/// Works as [ValueNotifier.addListener], but returns a cancelable
/// [Subscription] object
extension Subscribe<T> on ValueListenable<T> {
  /// Works as [ValueNotifier.addListener], but returns a cancelable
  /// [Subscription] object
  _Subscription<T> subscribe(
    void Function(T value) listener, {
    bool subscribe = true,
  }) =>
      _Subscription(this, () => listener(value), subscribe: subscribe);
}
