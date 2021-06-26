import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:value_extensions/value_extensions.dart';

class StateObject {
  /// Object main dispose bag.
  final _disposeBag = DisposeBag();

  /// Base private notifier that every other derives its value from.
  final _counter = ValueNotifier(0);

  /// Derived notifiers through [map()] extension
  late final ValueNotifier<Color> counterColor;
  late final ValueNotifier<String> stringCounterValue;

  /// Base stream for conversion demonstration
  final _timer = Stream.periodic(Duration(seconds: 1), (second) => second);

  /// Converted stream
  late final ValueNotifier<int> secondsPassed;

  /// Derived subscription using [where()] and [subscribe()] extensions
  late final Subscription evenPrintSubscription;

  StateObject() {
    _counter.disposedBy(_disposeBag);

    counterColor = _counter
        .map((value) => value.isEven ? Colors.red : Colors.blue)
        .disposedBy(_disposeBag);

    stringCounterValue =
        _counter.map((value) => value.toString()).disposedBy(_disposeBag);

    secondsPassed = _timer.extractValue(initial: 0).disposedBy(_disposeBag);

    evenPrintSubscription =
        _counter.where((value) => value.isEven).subscribe(print);
  }

  void increment() => _counter.set((value) => value + 1);

  void dispose() {
    if (!evenPrintSubscription.isCanceled) evenPrintSubscription.cancel();
    _disposeBag.clear();
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
