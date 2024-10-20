import 'subscriber.dart';

abstract interface class Publisher<Output, Failure extends Error> {
  void receive(Subscriber<Output, Failure> subscriber);
}
