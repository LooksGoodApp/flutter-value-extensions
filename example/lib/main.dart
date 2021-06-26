import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:value_extensions/value_extensions.dart';

class StateObject {
  final _disposeBag = DisposeBag();

  final _counter = ValueNotifier(0);
  late final ValueNotifier<Color> counterColor;
  late final ValueNotifier<String> stringCounterValue;

  late final Subscription evenPrintSubscription;

  StateObject() {
    _counter.disposedBy(_disposeBag);

    counterColor = _counter
        .map((value) => value.isEven ? Colors.red : Colors.blue)
        .disposedBy(_disposeBag);

    stringCounterValue =
        _counter.map((value) => value.toString()).disposedBy(_disposeBag);

    evenPrintSubscription = _counter
        .where((value) => value.isEven)
        .subscribe(print);
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
              DisposableBuilder(
                builder: (context, disposeBag) => state.stringCounterValue
                    .parallelWith(state.counterColor)
                    .disposedBy(disposeBag)
                    .bind(
                      (value) => Text(
                        value.first,
                        style: TextStyle(color: value.second),
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
