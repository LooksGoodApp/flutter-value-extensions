part of value_extensions;

/// [ValueNotifier] [Subscription] object that can be canceled. 
abstract class Subscription {
  bool get isCanceled;
  void cancel();
}

class _Subscription<T> extends Subscription {
  final ValueNotifier _listenable;
  final void Function() _listener;
  bool _isCanceled = false;

  _Subscription(this._listenable, this._listener) {
    _listenable.addListener(_listener);
  }

  void cancel() {
    _listenable.removeListener(_listener);
    _isCanceled = true;
  }

  bool get isCanceled => _isCanceled;
}

extension Subscribe<T> on ValueNotifier<T> {
  /// Works as [ValueNotifier.addListener], but returns a cancelable
  /// [Subscription] object
  _Subscription<T> subscribe(void Function(T value) listener) =>
      _Subscription(this, () => listener(value));
}
