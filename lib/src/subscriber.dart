import "subscription.dart";

abstract interface class Subscriber<Input, Failure extends Error> {
  void receive(Input input);

  void receiveSubscription(Subscription subscription);

  void receiveError(Failure failure);

  void receiveCompletion();
}
