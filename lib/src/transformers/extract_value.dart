import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:value_extensions/src/utility/setters.dart';

abstract class StreamValueListenable<A>
    implements ValueListenable<A>, ChangeNotifier {}

class _ExtractedValueNotifier<A> extends ValueNotifier<A>
    implements StreamValueListenable<A> {
  StreamSubscription<A>? _streamSubscription;

  _ExtractedValueNotifier(Stream<A> stream, A initialValue)
      : super(initialValue) {
    _streamSubscription =
        stream.listen(set, onDone: _streamSubscription?.cancel);
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    super.dispose();
  }
}

extension ExtractValueStreamExtension<A> on Stream<A> {
  StreamValueListenable<A> extractValue({required A initial}) =>
      _ExtractedValueNotifier(this, initial);
}
