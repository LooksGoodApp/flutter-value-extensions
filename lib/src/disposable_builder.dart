part of value_extensions;

/// Widget builder that is intended to be used when there is a need to create
/// a new [ValueNotifier] "in place" and insure that all resources will be
/// released.
///
/// Example usage:
///
/// ```dart
/// DisposableBuilder(
///   builder: (context, disposeBag) => someNotifier
///       .parallelWith(otherNotifier)
///       .disposedBy(disposeBag)
///       .bind((value) => Text("${value.first}, ${value.second}")),
/// )
/// ```
class DisposableBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, DisposeBag disposeBag) builder;
  DisposableBuilder({required this.builder});

  _DisposableBuilderState createState() => _DisposableBuilderState();
}

class _DisposableBuilderState extends State<DisposableBuilder> {
  late final _disposeBag = DisposeBag();

  @override
  void dispose() {
    _disposeBag.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _disposeBag);
}
