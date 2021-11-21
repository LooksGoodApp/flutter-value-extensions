# value_extensions

Set of extensions on ValueListenable that allows to use it as Streams in the Rx way. 

This package contains transformers, convenience objects & methods, and Widgets to integrate all listed entities into your UI.

## Motivation

Generally, there are two PubSub approaches for UI in Flutter: `Stream`s and `ValueListenable`s. Streams are widely used and can be good in some situations and are very powerful, but they come with a price: boilerplate. 

Controllers, Streams, Sinks, Sync/Async variations, broadcast/not broadcast streams. That is a lot to type and to keep in mind.

`ValueListenable`s, on the other hand, are a lot simpler, lighter, and need less code. But they lack Stream's power – it's hard to make derived notifiers, dispose of them automatically, subscribe and cancel subscriptions and integrated them without crazy nesting in UI. **Value Extensions** solves this problem.

## Getting started 

Down are listed all extensions with the use cases. For further information, visit API Reference or the Example.

## Core extensions

Those extensions provide base functionality: creating, setting, subscribing, and disposing of Notifiers.

### Set

`.set((current) => ...)` extension provides a better API for setting Notifiers' value.

Consider this example:

```dart
/// Traditional
someNotifier.value = someNotifier.value * 10;

/// Extension
someNotifier.set((current) => current * 10);
```

### Subscribe

ValueListenable provide subscription functionality out of the box, but it is a bit tricky to get information about their status and cancel them. This extension provides functionality for these cases.

```dart
final subscription = someValueListenable.subscribe((value) => print(value));

print(subscription.isCanceled); // Prints 'false'
someValueListenable.set((_) => 10); // Prints 10

subscription.cancel()

print(subscription.isCanceled); // Prints 'true'
someValueListenable.set((_) => 100); // Does not print
```

### Extract value

Sometimes, there is a need to convert a `Stream` to a `ValueListenable`. This extension does exactly that.

```dart
final stream = Stream.periodic(Duration(seconds: 1), (second) => second);
final secondsPassed = stream.extractValue(initial: 0);
```

## Transformers

The next section focuses on the transformation of the Notifiers. They implement the Iterator pattern and copy Stream's methods, so when base Notifier changes – derived Notifiers will change too.

### Map

Creates a new ValueListenable, deriving its value from the base one using the transform function.

```dart
final stringNotifier = ValueNotifier('Hello');
final lengthNotifier = stringNotifier.map((value) => value.length); // 5
stringNotifier.set((current) => current + ', World!'); // lengthNotifier value becomes 13
```

### Flat map

Works as a regular `.map()`, but takes a function that returns a ValueListenable and "flattens" the result. 

So instead of ValueListenable\<ValueListenable\<T\>\>, it becomes a regular ValueListenable\<T\>.

```dart
final intNotifier = ValueNotifier(0);
final stringNotifier = ValueNotifier('Hello!');

final isShowingInt = ValueNotifier(true);

final currentNotifier = isShowingInt.flatMap((isInt) => isInt ? intNotifier : stringNotifier);
```

### Where

Creates a new Notifier by filtering base Notifier's values, not including the first one. 

```dart
final intNotifier = ValueNotifier(1);

final evenNotifier = intNotifier.where((value) => value.isEven); // 1
final oddNotifier = intNotifier.where((value) => value.isOdd); // 1

// evenNotifier: 2
// oddNotifier: 1
intNotifier.set((value) => value + 1);
```

### Combine latest

Creates a new Notifier by combining its value with `other`'s value and feeding the pair to the transform function.

```dart
final stringNotifier = ValueNotifier('Flutter');
final boolNotifier = ValueNotifier(false);

final textNotifier = stringNotifier.combineLatest<bool>(
  boolNotifier, 
  (stringValue, boolValue) => boolValue ? stringValue.toUpperCase() : stringValue,
); // Flutter

boolNotifier.set((_) => true); // textNotifier value becomes FLUTTER
```

### Parallel with

Wrapper around the `.combineLatest(...)` extension. Packs latest values of the Notifiers in a tuple. Useful in UI to avoid nestings.

```dart
final intNotifier = ValueNotifier(0);
final boolNotifier = ValueNotifier(false);

final paralleledNotifier = intNotifier.parallelWith(boolNotifier); // (0, false)

intNotifier.set((current) => current + 1); // paralleledNotifier becomes (1, false)
boolNotifier.set((_) => true); // paralleledNotifier becomes (1, true)
```

## UI integrations

The last section focuses on UI integrations.

Both Streams and ValueNotifiers are intended to be displayed in the UI through Builders. The only problem is – builders are massive. To "bind" a single observable variable to the UI, one must type around 86 characters. Value Extensions reduces this number to around 23 characters or almost 4 times less!

### Bind

To bind a ValueListenable to the UI, the `.bind(...)` extension is used. 

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

The `.bind(...)` extension uses `ValueListenableBuilder` inside, so you'll have the same efficient targeted rebuilds, but with less code to type.

### Disposable builder

Sometimes, it is convenient to create a new `ValueNotifier` in the UI, combining notifiers from different state objects. And to be sure that resources are being released properly, the `DisposableBuilder` can be used.

The most frequent use of the `DisposableBuilder` is in combination with the `parallelWith(...)` extension. Example usage would look like this.

```dart 
DisposableBuilder(
  builder: (context, disposeBag) => state.stringCounterValue
      .parallelWith(state.counterColor)
      .disposedBy(disposeBag)
      .bind(
        (text, color) => Text(
          text,
          style: TextStyle(color: color),
        ),
      ),
),
```

Note – the `.bind(...)` extension used on the Notifier obtained from the `.parallelWith(...)` extension automatically destructures its value in the Widget callback.