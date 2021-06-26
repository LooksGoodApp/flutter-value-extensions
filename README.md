# value_extensions

Set of extensions on ValueNotifier that allows to use it as Streams in the Rx way. 

This package contains transformers, convenience objects & methods, and Widgets to integrate all listed entities into your UI.

## Motivation

Generally, there are two PubSub approaches for UI in Flutter: `Stream`s and `ValueNotifier`s. Streams are widely used and can be good in some situations and are very powerful, but they come with a price: boilerplate. 

Controllers, Streams, Sinks, Sync/Async variations, broadcast/not broadcast streams. That is a lot to type and to keep in mind.

`ValueNotifier`s, on the other hand, are a lot simpler, lighter and need less code. But they lack Stream's power – it's hard to make derived notifiers, dispose them automatically, subscribe and cancel subscriptions and integrated them without crazy nesting in UI. **Value Extensions** solves this problem.

## Getting started 

Down are listed all extensions with the use cases. For further information, visit API Reference or the Example;

## Core extensions

Those extensions provide base functionality: creating, setting, subscribing and disposing of Notifiers.

### Set

`.set((current) => ...)` extension provides a better API for setting Notifiers.

Consider this example:

```dart
/// Traditional
someNotifier.value = someNotifier.value * 10;

/// Extension
someNotifier.set((current) => current * 10);
```

### Subscribe

ValueNotifiers provide subscription functionality out of the box, but it is a bit tricky to get information about their status and cancel them. This extension provides functionality for this cases.

```dart
final subscription = someValueNotifier.subscribe((value) => print(value));

print(subscription.isCanceled); // Prints 'false'
someValueNotifier.set((current) => 10); // Prints 10

subscription.cancel()

print(subscription.isCanceled); // Prints 'true'
someValueNotifier.set((current) => 100); // Does not print
```

### Extract value

Sometimes, there is a need to convert a `Stream` to a `ValueNotifier`. This extension does exactly that.

```dart
final secondsPassed = Stream.periodic(Duration(seconds: 1), (second) => second).extractValue(initial: 0);
```

### Dispose

Just as `Streams`, `ValueNotifiers`s need to be properly disposed in order for resources to be released. Regular approach usually would look like a dispose method with a bunch of `someNotifier.dispose()`s in it in the revers order of their creation.

Value Extensions provide a more pleasant way of doing so – `DisposeBag` and `.disposedBy(disposeBag)`.

`DisposeBag` is a simple container that stores notifiers that need to be disposed. It has a single method – `clear()` that disposes every service that was added to it in a reverse order.

`.disposedBy(disposeBag)` is an extension that adds a `ValueNotifier` to an instance of a `DisposeBag`.

Example usage would look like this.

```dart 
final disposeBag = DisposeBag();

final intNotifier = ValueNotifier(0).disposedBy(disposeBag);
final stringNotifier = ValueNotifier('Hello, Wold!').disposedBy(disposeBag);

disposeBag.clear(); // Disposes notifiers in reverse order of being added: stringNotifier -> intNotifier.
```

## Transformers



### Map
### Flat map
### Where
### Combine latest
### Parallel with

## UI integrations

### Bind
### Disposable builder
