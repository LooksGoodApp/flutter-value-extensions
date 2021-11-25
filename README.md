# value_extensions

Set of extensions on ValueListenable that allows to use it as Streams in the Rx way. 

This package contains transformers, convenience objects & methods, and Widgets to integrate all listed entities into your Widgets.

## Motivation

Generally, there are two PubSub approaches for Widgets in Flutter: `Stream`s and `Listenable`s. Streams are widely used and can be good in some situations and are very powerful, but they come with a price: boilerplate. 

To have a stateful `Stream` with a getter of its last value it is needed to:
  1) Create a `StreamController`
  2) Expose a `Stream`
  3) Create a mutable cache variable
  4) Expose a getter of that variable
  5) Every time the cached value is mutated, the new value must be added in the `Sink`

And to use it in Widgets through `StreamBuilder`, it also needed to provide both the `stream` argument and the `initialValue` argument.

That's a lot of code.

`ValueListenable`s, on the other hand, are a lot simpler and need a lot less code. But they lack Stream's power – it's hard to make derived notifiers, dispose of them automatically, subscribe and cancel subscriptions, and integrate them without crazy nesting in UI. **Value Extensions** solves this problem.

## Getting started 

Down are listed all extensions with the use cases. For further information, visit API Reference or the Example.

## Utility extensions

Those extensions provide base functionality: creating, setting, subscribing, and disposing of Notifiers.

### Set

`.set(...)` extension provides a better API for setting `ValueNotifier`'s value to another and is strictly equivalent to the default `.value` setter. Using the `.set` method is more concise and states the intent a bit better. The following two examples are equivalent:

```dart
someNotifier.value = 10;

someNotifier.set(10);
```

### Update

`.update((current) => ...)` extension provides a better API for setting `ValueNotifier`'s value when the new value depends on the previous one.

Consider this example:

```dart
int timesTwo(int x) => x * 2;
  
/// Traditional
someNotifier.value = timesTwo(someNotifier.value);

/// Extension
someNotifier.update(timesTwo);
```

### Subscribe

ValueListenable provides subscription functionality out of the box, but it is a bit tricky to get information about their status and cancel them. This extension provides functionality for these cases.

```dart
final subscription = someValueListenable.subscribe(print);

print(subscription.isCanceled); // Prints 'false'
someValueListenable.set((_) => 10); // Prints 10

subscription.cancel()

print(subscription.isCanceled); // Prints 'true'
someValueListenable.set((_) => 100); // Does not print
```

It is also possible to pause and resume a subscription.

### Extract value

Sometimes, there is a need to convert a `Stream` to a `ValueListenable`. This extension does exactly that.

```dart
final stream = Stream.periodic(Duration(seconds: 1), (second) => second);
final secondsPassed = stream.extractValue(initial: 0);
```

## Transformers

The next section focuses on the transformation of the ValueListenables. They implement the Iterator pattern and copy Stream's methods, so when base ValueListenable changes – derived ValueListenables will change too.

### Map

Creates a new ValueListenable, deriving its value from the base one using the transform function.

```dart
final stringNotifier = ValueNotifier('Hello');
final lengthListenable = stringNotifier.map((value) => value.length); // 5
stringNotifier.update((hello) => '$hello, World!'); // lengthNotifier value becomes 13
```

### Flat map

Works like `map` but transform function must return another `ValueListenable` instead of regular value, recomputing its value whenever the `ValueListenable` on which the `flatMap` was called changes.

```dart
final intNotifier = ValueNotifier(0);

final stringNotifier = ValueNotifier('Hello!');
final lengthListenable = stringNotifier.map((string) => string.length);

final isShowingInt = ValueNotifier(true);

final currentValue = isShowingInt.flatMap((isInt) => isInt ? intNotifier : lengthListenable);
```

### Where

Creates a new `ValueListenable` by filtering base `ValueListenable`'s values, not including the first one. 

```dart
final intNotifier = ValueNotifier(1);

final evenListenable = intNotifier.where((value) => value.isEven); // 1
final oddListenable = intNotifier.where((value) => value.isOdd); // 1

// evenListenable: 2
// oddListenable: 1
intNotifier.update((value) => value + 1);
```

### Combine latest

Creates a new `ValueListenable` by combining its value with `other`'s value and feeding the pair to the transform function.

```dart
final word = ValueNotifier('Flutter');
final isUppercased = ValueNotifier(false);

final textListenable = word.combineLatest<bool, String>(
  isUppercased, 
  (word, isUppercased) => isUppercased ? word.toUpperCase() : word,
); // Flutter

isUppercased.set(true); // textNotifier value becomes FLUTTER
```

### Parallel with

Wrapper around the `.combineLatest(...)` extension. Packs latest values of the `ValueListenable` in a tuple. Useful in Widgets to avoid nestings of `ValueListenableBuilder`s or `.bind` calls.

```dart
final intNotifier = ValueNotifier(0);
final boolNotifier = ValueNotifier(false);

final paralleled = intNotifier.parallelWith(boolNotifier); // (0, false)

intNotifier.update((current) => current + 1); // paralleled becomes (1, false)
boolNotifier.set(true); // paralleled becomes (1, true)
```

## Widgets integrations

The last section focuses on Widgets integrations.

Both `Streams` and `ValueListenable`s are intended to be displayed in the UI through Builders. The only problem is – builders are pretty verbose. To "bind" a single observable variable to some Widget, one must type around 86 characters. Value Extensions reduces this number to around 23 characters or almost 4 times less!

### Bind

To bind a `ValueListenable` to a Widget, the `.bind(...)` extension is used. 

Consider these two examples: using `ValueListenableBuilder` and `.bind(...)`.

```dart
ValueListenableBuilder(
  valueListenable: nameNotifier,
  builder: (context, name, child) => Text("Hello, $name!"),
)
```

```dart 
nameNotifier.bind(
  (name) => Text("Hello, $name!"),
)
```

The `.bind(...)` extension uses `ValueListenableBuilder` inside, so it results in the same efficient targeted rebuilds, but with less code to type.

Note – the `.bind(...)` extension used on the `ValueListenable` obtained from the `.parallelWith(...)` extension automatically destructures its value in the builder callback.