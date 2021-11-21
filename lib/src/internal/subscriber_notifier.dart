import 'package:flutter/material.dart';
import 'package:value_extensions/src/internal/subscriber_watcher_mixin.dart';
import 'package:value_extensions/src/internal/subscriptions_watcher_notifier_mixin.dart';

abstract class SubscriberNotifier<A> = ValueNotifier<A>
    with SubscriptionsWatcherNotifierMixin<A>, SubscriberWatcherMixin<A>;
