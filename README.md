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

### Set
### Subscribe
### Extract value
### Dispose

## Transformers

### Map
### Flat map
### Where
### Combine latest
### Parallel with

## UI integrations

### Bind
### Disposable builder
