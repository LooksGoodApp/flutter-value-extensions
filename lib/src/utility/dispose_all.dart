import 'package:flutter/foundation.dart';

void disposeAll(
  List<ChangeNotifier> disposables,
) =>
    disposables.reversed.forEach((disposable) => disposable.dispose());
