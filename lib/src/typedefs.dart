import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A function that takes a single argument.
typedef UnaryFunction<A, B> = B Function(A value);

/// A function that takes two arguments.
typedef BinaryFunction<A, B, C> = C Function(A first, B second);

/// A unary function that returns a [bool].
typedef Predicate<A> = UnaryFunction<A, bool>;

/// A unary function that returns a ValueListenable.
/// Used by the [ValueListenableFlatMapExtension].
typedef FlatMapTransform<A, B> = UnaryFunction<A, ValueListenable<B>>;

/// A unary function that takes and returns the same type.
/// Used by the [ValueNotifierSettersExtension] extension.
typedef Endomorphic<A> = UnaryFunction<A, A>;

/// A unary function that returns [void].
typedef UnaryVoidCallback<A> = UnaryFunction<A, void>;

/// A unary function that returns [Widget].
typedef UnaryWidgetBuilder<A> = UnaryFunction<A, Widget>;

/// A binary function that returns [Widget].
typedef BinaryWidgetBuilder<A, B> = BinaryFunction<A, B, Widget>;
