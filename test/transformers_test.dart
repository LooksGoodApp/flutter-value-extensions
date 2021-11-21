// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:value_extensions/value_extensions.dart';

void main() {
  int timesTwo(int x) => x * 2;

  group(
    "Map transformer tests",
    () {
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
        subscription.pause();
        source.set(3);
        expect(mapped.value, 6); // invoked = 4
        source.set(100); // No effect on invoked – not read and not listened to
        subscription.pause(); // invoked = 5
        source.set(2); // invoked = 6
        expect(invoked, 6);
        source.dispose();
      });
    },
  );
}
