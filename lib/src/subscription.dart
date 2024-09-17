import 'package:dart_combine/src/cancellables.dart';

abstract class Subscription {
  void cancel();
}

extension SubscriptionExtension on Subscription {
  void store(Cancellables cancellables) {
    cancellables.add(this);
  }
}