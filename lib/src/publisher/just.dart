
import 'package:dart_combine/dart_combine.dart';

final class Just<Output> implements Publisher<Output, Never> {
  final Output _value;

  Just(this._value);

  @override
  void receive(Subscriber<Output, Never> subscriber) {
    subscriber.receive(_value);
    subscriber.receiveCompletion();
  }
}