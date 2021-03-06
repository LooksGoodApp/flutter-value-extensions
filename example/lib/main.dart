import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:value_extensions/value_extensions.dart';

class StateObject {
  /// Base private notifier that every other derives its value from.
  final _counter = ValueNotifier(0);

  late final StreamValueListenable<int> _secondsPassed =
      _timer.extractValue(initial: 0);

  /// Base stream for conversion demonstration
  final _timer =
      Stream.periodic(const Duration(seconds: 1), (second) => second);

  /// Derived subscription using [where()] and [subscribe()] extensions
  late final Subscription evenPrintSubscription;

  StateObject() {
    evenPrintSubscription =
        _counter.where((value) => value.isEven).subscribe(print);
  }

  ValueListenable<Color> get counterColor =>
      _counter.map((value) => value.isEven ? Colors.red : Colors.blue);

  ValueListenable<String> get stringCounterValue =>
      _counter.map((value) => value.toString());

  ValueListenable<int> get secondsPassed => _secondsPassed;

  List<ChangeNotifier> get _disposable => [_counter, _secondsPassed];

  void increment() => _counter.update((value) => value + 1);

  void dispose() {
    evenPrintSubscription.cancel();
    _disposable.disposeAll();
    print("Disposed $this");
  }
}

class CounterScreen extends StatefulWidget {
  @override
  CounterScreenState createState() => CounterScreenState();
}

class CounterScreenState extends State {
  final state = StateObject();

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state.secondsPassed.bind(
                (seconds) => Text("Seconds passed: $seconds"),
              ),
              const SizedBox(height: 100),
              state.stringCounterValue.parallelWith(state.counterColor).bind(
                    (text, color) => Text(
                      text,
                      style: TextStyle(color: color),
                    ),
                  ),
              OutlinedButton(
                onPressed: state.increment,
                child: const Text("Increment"),
              ),
              OutlinedButton(
                onPressed: state.evenPrintSubscription.cancel,
                child: const Text("Cancel print"),
              ),
              OutlinedButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("Navigate back"),
              ),
            ],
          ),
        ),
      );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Home")),
        body: Center(
          child: OutlinedButton(
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute(builder: (context) => CounterScreen()),
            ),
            child: const Text("Navigate to Counter"),
          ),
        ),
      );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Home(),
      );
}

void main() {
  runApp(MyApp());
}
