import 'package:dart_combine/dart_combine.dart';

final class Empty<Output> implements Publisher<Output, Never> {
  Empty();

  @override
  void receive(Subscriber<Output, Never> subscriber) {
    subscriber.receiveCompletion();
  }
}