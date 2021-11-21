// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:value_extensions/value_extensions.dart';

void main() {
  int timesTwo(int x) => x * 2;
  int sum(int x, int y) => x + y;
  Future<void> nextEventLoop() => Future.delayed(Duration.zero);

  group("Map transformer tests >", () {
    test("Changing value without listening", () {
      final source = ValueNotifier(1);
      final mapped = source.map(timesTwo);
      expect(mapped.value, 2);
      source.set(2);
      expect(mapped.value, 4);
      source.dispose();
    });
    test("Changing value with listening", () {
      final source = ValueNotifier(1);
      final mapped = source.map(timesTwo)..subscribe((_) {});
      expect(mapped.value, 2);
      source.set(2);
      expect(mapped.value, 4);
      source.dispose();
    });
    test("Changing value and changing subscription status", () {
      var invoked = 0;

      int timesTwoCounting(int x) {
        invoked++;
        return x * 2;
      }

      final source = ValueNotifier(1);
      final mapped = source.map(timesTwoCounting); // invoked = 1
      final subscription = mapped.subscribe((_) {}); // invoked = 2
      expect(mapped.value, 2);
      expect(invoked, 2);
      source.set(2); // invoked = 3
      expect(mapped.value, 4);
      subscription.pause(); // Subscription paused
      source.set(3);
      expect(mapped.value, 6); // Value is read, invoked = 4
      source.set(100); // No effect on invoked – not read and not listened to
      subscription.pause(); // Subscription resumed, invoked = 5
      source.set(2); // invoked = 6
      expect(invoked, 6);
      source.dispose();
    });
  });

  group("Where transformer test >", () {
    test("Initial value is ignored", () {
      const odd = 3;
      expect(ValueNotifier(odd).where((value) => value.isEven).value, odd);
    });

    test("Filtering source", () {
      final source = ValueNotifier(0);
      final filtered = source.where((value) => value.isOdd);
      expect(filtered.value, 0);
      source.set(1);
      expect(filtered.value, 1);
      source.set(2);
      expect(filtered.value, 1);
      source.set(3);
      expect(filtered.value, 3);
      source.set(4);
      expect(filtered.value, 3);
    });
  });

  group("Combine latest transformer test >", () {
    test("Initial value is calculated straight away", () {
      final first = ValueNotifier(1);
      final second = ValueNotifier(1);
      final combined = first.combineLatest(second, sum);
      final matcher = sum(first.value, second.value);
      expect(combined.value, matcher);
    });

    test("Combining latest values", () {
      final first = ValueNotifier(1);
      final second = ValueNotifier(1);
      final combined = first.combineLatest(second, sum);
      var currentValue = first.value + second.value;
      combined.subscribe((value) {
        currentValue = value;
      });
      expect(currentValue, 2);
      first.set(9);
      expect(currentValue, 10);
      second.set(6);
      expect(currentValue, 15);
      first.set(10);
      second.set(10);
      expect(first.value + second.value, 20);
    });
  });

  group("Extract value transformer test >", () {
    test("Derived notifier starts with a passed initial value", () {
      const emptyStream = Stream<int>.empty();
      const initial = 0;
      final extracted = emptyStream.extractValue(initial: initial);
      expect(extracted.value, initial);
    });

    test("Derived notifier echoes synchronous stream", () {
      final streamSource = StreamController<int>.broadcast(sync: true);
      final sourceAdd = streamSource.sink.add;
      final derivedNotifier = streamSource.stream.extractValue(initial: 0);

      const firstAdded = 10;
      sourceAdd(firstAdded);
      expect(derivedNotifier.value, firstAdded);

      const secondAdded = -5;
      sourceAdd(secondAdded);
      expect(derivedNotifier.value, secondAdded);

      streamSource.close();
      derivedNotifier.dispose();
    });

    test("Derived notifier echoes asynchronous stream", () async {
      final streamSource = StreamController<int>.broadcast();
      final sourceAdd = streamSource.sink.add;
      final derivedNotifier = streamSource.stream.extractValue(initial: 0);

      const firstAdded = 10;
      sourceAdd(firstAdded);
      await nextEventLoop();
      expect(derivedNotifier.value, firstAdded);

      const secondAdded = -5;
      sourceAdd(secondAdded);
      await nextEventLoop();
      expect(derivedNotifier.value, secondAdded);

      await streamSource.close();
      derivedNotifier.dispose();
    });
  });
}
