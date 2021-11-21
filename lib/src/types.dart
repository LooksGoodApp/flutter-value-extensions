import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef UnaryFunction<A, B> = B Function(A value);
typedef BinaryFunction<A, B, C> = C Function(A first, B second);
typedef Predicate<A> = UnaryFunction<A, bool>;
typedef FlatMapTransform<A, B> = UnaryFunction<A, ValueListenable<B>>;
typedef Endomorphic<A> = UnaryFunction<A, A>;
typedef UnaryVoidCallback<A> = UnaryFunction<A, void>;
typedef UnaryWidgetBuilder<A> = UnaryFunction<A, Widget>;
typedef BinaryWidgetBuilder<A, B> = BinaryFunction<A, B, Widget>;

class Pair<A, B> {
  final A first;
  final B second;
  const Pair._(this.first, this.second);
}
