import 'package:flutter/material.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:value_extensions/value_extensions.dart';

void main() {
  group("Setters test >", () {
    group("Set method test >", () {
      test("Set changes the value", () {
        final source = ValueNotifier(0);
        expect(source.value, 0);

        source.set(1);
        expect(source.value, 1);

        source.set(10);
        expect(source.value, 10);

        source.set(5);
      });

      test("Set is identical to the value setter", () {
        final setterNotifier = ValueNotifier(0);
        final methodNotifier = ValueNotifier(0);

        expect(setterNotifier.value, 0);
        expect(methodNotifier.value, 0);

        setterNotifier.value = 10;
        methodNotifier.set(10);

        expect(setterNotifier.value, 10);
        expect(methodNotifier.value, 10);

        setterNotifier.value = 5;
        methodNotifier.set(5);

        expect(setterNotifier.value, 5);
        expect(methodNotifier.value, 5);
      });
    });

    group("Update method test >", () {
      int timesTwo(int x) => x * 2;

      test("Update changes the value", () {
        final source = ValueNotifier(1);
        expect(source.value, 1);

        source.update(timesTwo);
        expect(source.value, 2);

        source.update(timesTwo);
        expect(source.value, 4);
      });

      test("Update is identical to the value setter", () {
        final setterNotifier = ValueNotifier(1);
        final methodNotifier = ValueNotifier(1);

        expect(setterNotifier.value, 1);
        expect(methodNotifier.value, 1);

        setterNotifier.value = timesTwo(setterNotifier.value);
        methodNotifier.update(timesTwo);
        expect(setterNotifier.value, 2);
        expect(methodNotifier.value, 2);

        setterNotifier.value = timesTwo(setterNotifier.value);
        methodNotifier.update(timesTwo);
        expect(setterNotifier.value, 4);
        expect(methodNotifier.value, 4);
      });
    });
  });

  group("Subscriptions test >", () {
    test("General listening", () {
      final source = ValueNotifier<bool>(true);
      var notified = 0;

      source.subscribe((_) => notified++);
      expect(notified, 0);

      source.set(false);
      expect(notified, 1);

      source..set(true)..set(false)..set(true)..set(false);
      expect(notified, 5);
    });

    test("Cancellation", () {
      final source = ValueNotifier<bool>(true);
      var notified = 0;

      final subscription = source.subscribe((_) => notified++);
      expect(notified, 0);

      source.set(false);
      expect(notified, 1);

      subscription.cancel();

      source..set(true)..set(false)..set(true)..set(false);
      expect(notified, 1);
    });

    test("Pausing", () {
      final source = ValueNotifier<bool>(true);
      var notified = 0;

      final subscription = source.subscribe((_) => notified++);
      expect(notified, 0);

      source.set(false);
      expect(notified, 1);

      subscription.pause();

      source..set(true)..set(false)..set(true)..set(false);
      expect(notified, 1);

      subscription.pause();

      source..set(true)..set(false)..set(true)..set(false);
      expect(notified, 5);
    });
  });

  group("Cancellation tests >", () {
    const flutterError = TypeMatcher<FlutterError>();
    test("Single notifier", () {
      final source = ValueNotifier(0);
      final single = <ChangeNotifier>[source];
      expect(() => source.set(10), returnsNormally);
      single.disposeAll();
      expect(() => source.set(100), throwsA(flutterError));
    });

    test("List of notifiers", () {
      final notifiers = [ValueNotifier(0), ValueNotifier(1), ValueNotifier(2)];
      for (final notifier in notifiers) {
        expect(() => notifier.set(10), returnsNormally);
      }
      notifiers.disposeAll();
      for (final notifier in notifiers) {
        expect(() => notifier.set(100), throwsA(flutterError));
      }
    });
  });
}
