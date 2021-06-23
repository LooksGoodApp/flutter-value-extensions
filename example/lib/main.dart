import 'package:flutter/material.dart';
import 'package:value_extensions/value_extensions.dart';

class StateObject {
  final _disposeBag = DisposeBag();

  final counterValue = ValueNotifier(0);
  late final ValueNotifier<int> evenCounterValue;
  late final ValueNotifier<String> stringCounterValue;

  late final Subscription evenPrintSubscription;

  StateObject() {
    counterValue.disposedBy(_disposeBag);
    evenCounterValue =
        counterValue.where((value) => value.isEven).disposedBy(_disposeBag);
    stringCounterValue = counterValue.map((value) => value.toString());
    evenPrintSubscription = evenCounterValue.subscribe(print);
  }

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

class CounterScreen extends StatelessWidget {
  final state = StateObject();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state.stringCounterValue.bind(
                (value) => Text(value),
              ),
              OutlinedButton(
                onPressed: () => state.counterValue.value++,
                child: Text("Increment"),
              ),
              OutlinedButton(
                onPressed: state.evenPrintSubscription.cancel,
                child: Text("Cancel print"),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  state.dispose();
                },
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
