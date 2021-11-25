## [0.2.0] - 25.11.2021

### Breaking changes

- Every derived Object obtained from transformer extensions is now a `ValueListenable` instead of `ValueNotifier`.
- Removed DisposeBag.
- Removed DisposableBuilder.
- Extract value Extension (`.extractValue(...)`) extensions now returns `StreamValueListenable`.
- Set Extension (`.set(...)`) now takes a value instead of a function.

### Non-Breaking changes

- Added Dispose all Extension (`.disposeAll()`). It is a replacement for the `DisposeBag` object.
- Added Update Extension (`.update(...)`). It is a replacement for the `.set` extension method.
- Derived `ValueListenable`s are now lazy and efficient – they don't compute anything if not listened to.

### Misc

- Package now follows guidelines in terms of usage of the `part of` directive, it is now removed
- Package now uses a custom linter 
- Every transformer now has full test coverage

## [0.1.0] - 26.06.2021

- Updated example
- Updated README
- Added `.extractValue(...)` extension
- [BREAKING CHANGES] `.bind(...)` extension used on the paralleled notifier obtained from `.parallelWith(...)` extension destructures its value

## [0.0.1] - 23.06.2021

- Initial release