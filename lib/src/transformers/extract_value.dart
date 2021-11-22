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

/// {@template extract_value.extension}
/// Creates a new [StreamValueListenable] that echoes the stream, converting it
/// to [ValueListenable].
///
/// The [StreamValueListenable] implements [ChangeNotifier] to expose
/// the [dispose] method. It is mandatory to call it on the obtained Listenable
/// because it cancels the [StreamSubscription] under the hood.
/// {@endtemplate}
extension StreamExtractValueExtension<A> on Stream<A> {
  /// {@macro extract_value.extension}
  StreamValueListenable<A> extractValue({required A initial}) =>
      _ExtractedValueNotifier(this, initial);
}
