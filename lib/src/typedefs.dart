import 'package:flutter/foundation.dart';

typedef UnaryTransform<A, B> = B Function(A a);
typedef BinaryTransform<A, B, C> = C Function(A a, B b);
typedef FlatMapTransform<A, B> = UnaryTransform<A, ValueListenable<B>>;
