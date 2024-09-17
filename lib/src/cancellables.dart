import 'package:dart_combine/dart_combine.dart';

final class Cancellables {
  final List<Subscription> _subscriptions = [];

  void add(Subscription subscription) {
    _subscriptions.add(subscription);
  }

  void cancel() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
  }
}