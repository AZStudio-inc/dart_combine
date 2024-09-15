
import 'package:dart_combine/dart_combine.dart';

class Just<Output> extends Publisher<Output, Never> {
  final Output _value;

  Just(this._value);

  @override
  void receive(Subscriber<Output, Never> subscriber) {
    subscriber.receive(_value);
    subscriber.receiveCompletion();
  }
}