part of value_extensions;

/// Carrier-object that makes [ValueNotifier] disposal easier.
/// 
/// Calling [DisposeBag.clear()] will dispose added notifier in revers order 
/// that they were added, allowing to declare disposal top-to-bottom instead
/// of traditional bottom-to-top.
class DisposeBag {
  final _notifiers = <ValueNotifier>[];

  void _add(ValueNotifier instance) => _notifiers.add(instance);

  void clear() {
    for (final notifier in _notifiers.reversed) {
      notifier.dispose();
    }
  }
}

extension Disposed<T> on ValueNotifier<T> {
  ValueNotifier<T> disposedBy(DisposeBag disposeBag) {
    disposeBag._add(this);
    return this;
  }
}
