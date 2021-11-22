import 'package:flutter/foundation.dart';

/// {@template dispose_all.extension}
/// Invokes the [dispose] method on every [ChangeNotifier] in the reverse order
/// of the list.
/// {@endtemplate}
extension ListChangeNotifierDisposeAllExtension on List<ChangeNotifier> {
  /// {@macro dispose_all.extension}
  void disposeAll() => reversed.forEach((disposable) => disposable.dispose());
}
