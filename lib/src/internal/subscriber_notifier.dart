import 'package:flutter/material.dart';
import 'package:value_extensions/src/internal/subscriber_watcher_mixin.dart';
import 'package:value_extensions/src/internal/subscriptions_watcher_notifier_mixin.dart';

/// Internal abstract class that allows subscribing to a single ValueListenable,
/// modifying its value when it changes and executing callbacks when it obtains
/// the first subscriber or loses the last one.
///
/// The actual subscription to the base listenable is active only when the
/// [SubscriberNotifier] itself has listeners.
abstract class SubscriberNotifier<A> = ValueNotifier<A>
    with SubscriptionsWatcherNotifierMixin, SubscriberWatcherMixin<A>;
