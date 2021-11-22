import 'package:flutter/foundation.dart';

extension ListChangeNotifierDisposeAllExtension on List<ChangeNotifier> {
  void disposeAll() => reversed.forEach((disposable) => disposable.dispose());
}
