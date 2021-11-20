import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:value_extensions/value_extensions.dart';

class StateObject {
  /// Base private notifier that every other derives its value from.
  final _counter = ValueNotifier(0);

  /// Base stream for conversion demonstration
  final _timer = Stream.periodic(Duration(seconds: 1), (second) => second);

  /// Derived subscription using [where()] and [subscribe()] extensions
  late final Subscription evenPrintSubscription;

  StateObject() {
    evenPrintSubscription =
        _counter.where((value) => value.isEven).subscribe(print);
  }

  ValueListenable<Color> get counterColor =>
      _counter.map((value) => value.isEven ? Colors.red : Colors.blue);

  ValueNotifier<String> get stringCounterValue =>
      _counter.map((value) => value.toString());

  ValueListenable<int> get secondsPassed => _timer.extractValue(initial: 0);

  void increment() => _counter.update((value) => value + 1);

  void dispose() {
    evenPrintSubscription.cancel();
    _counter.dispose();
    print("Disposed $this");
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Home")),
        body: Center(
          child: OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CounterScreen()),
            ),
            child: Text("Navigate to Counter"),
          ),
        ),
      );
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
              SizedBox(height: 100),
              state.stringCounterValue.parallelWith(state.counterColor).bind(
                    (text, color) => Text(
                      text,
                      style: TextStyle(color: color),
                    ),
                  ),
              OutlinedButton(
                onPressed: state.increment,
                child: Text("Increment"),
              ),
              OutlinedButton(
                onPressed: state.evenPrintSubscription.cancel,
                child: Text("Cancel print"),
              ),
              OutlinedButton(
                onPressed: Navigator.of(context).pop,
                child: Text("Navigate back"),
              ),
            ],
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
