import 'subscriber.dart';

abstract class Publisher<Output, Failure extends Error> {
  void receive(Subscriber<Output, Failure> subscriber);
}
