import 'package:dart_combine/dart_combine.dart';

extension PublisherSink<Input> on Publisher<Input, Never> {
  Subscription sink(void Function(Input) onReceive, {
    void Function()? onReceiveCompletion,
  }) {
    final sink = Sink<Input, Never>(
      onReceive: onReceive,
      onReceiveError: (error) {},
      onReceiveCompletion: onReceiveCompletion,
    );

    this.receive(sink);

    return sink;
  }
}

extension PublisherCatchSink<Input, Failure extends Error> on Publisher<Input, Failure> {
  Subscription catchSink(void Function(Input) onReceive, {
    required void Function(Failure) onReceiveError,
    void Function()? onReceiveCompletion,
  }) {
    final sink = Sink<Input, Failure>(
      onReceive: onReceive,
      onReceiveError: onReceiveError,
      onReceiveCompletion: onReceiveCompletion,
    );

    this.receive(sink);

    return sink;
  }
}

final class Sink<Input, Failure extends Error> implements Subscriber<Input, Failure>, Subscription {
  final void Function(Input) _onReceive;
  final void Function(Failure) _onReceiveError;
  final void Function()? _onReceiveCompletion;
  
  final List<Subscription> _subscriptions = [];

  Sink({
    required void Function(Input) onReceive,
    required void Function(Failure) onReceiveError,
    required void Function()? onReceiveCompletion,
  })   : _onReceive = onReceive,
        _onReceiveError = onReceiveError,
        _onReceiveCompletion = onReceiveCompletion;

  @override
  void cancel() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }

    _subscriptions.clear();
  }

  @override
  void receive(Input input) {
    this._onReceive(input);
  }

  @override
  void receiveSubscription(Subscription subscription) { 
    _subscriptions.add(subscription);
  }

  @override
  void receiveError(Failure failure) {
    this._onReceiveError(failure);
  }

  @override
  void receiveCompletion() {
    this._onReceiveCompletion?.call();
  }
}