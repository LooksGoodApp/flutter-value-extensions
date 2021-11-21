import 'package:flutter/material.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:value_extensions/value_extensions.dart';

void _transformerTest({
  required String name,
  required VoidCallback withoutListening,
  required VoidCallback withListening,
  required VoidCallback unsubscribing,
}) =>
    group(
      "$name transformer tests",
      () {
        test("Changing value without listening", withoutListening);
        test("Changing value with listening", withoutListening);
        test("Changing value and changing subscription status",
            withoutListening);
      },
    );

void main() {
  int timesTwo(int x) => x * 2;

  _transformerTest(
    name: "Map",
    withoutListening: () {
      final source = ValueNotifier(1);
      final mapped = source.map(timesTwo);
      expect(mapped.value, 2);
      source.set(2);
      expect(mapped.value, 4);
      source.dispose();
    },
    withListening: () {
      final source = ValueNotifier(1);
      final mapped = source.map(timesTwo)..subscribe((_) {});
      expect(mapped.value, 2);
      source.set(2);
      expect(mapped.value, 4);
      source.dispose();
    },
    unsubscribing: () {
      final source = ValueNotifier(1);
      final mapped = source.map(timesTwo);
      final subscription = mapped.subscribe((_) {});
      expect(mapped.value, 2);
      source.set(2);
      expect(mapped.value, 4);
      subscription.pause();
      source.set(3);
      expect(mapped.value, 6);
      subscription.pause();
      source.set(2);
      expect(mapped.value, 4);
      source.dispose();
    },
  );
}
