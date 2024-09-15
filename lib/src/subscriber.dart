import "subscription.dart";


abstract class Subscriber<Input, Failure extends Error> {
  void receive(Input input);

  void receiveSubscription(Subscription subscription);

  void receiveError(Failure failure);

  void receiveCompletion();
}
