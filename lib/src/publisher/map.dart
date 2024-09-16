
import 'package:dart_combine/dart_combine.dart';

extension PublisherMapExtension<Input, Failure extends Error, Upstream extends Publisher<Input, Failure>> on Publisher<Input, Failure> {
  Publisher<Output, Failure> map<Output>(Output Function(Input) transform) {
    return Map(
      upstream: this,
      transform: transform,
    );
  }
}

final class Map<Input, Output, Failure extends Error, Upstream extends Publisher<Input, Failure>> implements Publisher<Output, Failure> {
  final Output Function(Input) _transform;
  final Upstream _upstream;

  const Map({
    required Upstream upstream,
    required Output Function(Input) transform,
  }) : _transform = transform,
        _upstream = upstream;

  @override
  void receive(Subscriber<Output, Failure> subscriber) {
    final inner = _MapInner(downstream: subscriber, transform: _transform);
    _upstream.receive(inner);
  }
}

final class _MapInner<Input, Output, Failure extends Error> implements Subscriber<Input, Failure> {
  final Subscriber<Output, Failure> _downstream;
  final Output Function(Input) _transform;

  _MapInner({
    required Subscriber<Output, Failure> downstream,
    required Output Function(Input) transform,
  }) : _downstream = downstream, 
       _transform = transform;

  @override
  void receive(Input input) {
    final output = _transform(input);
    _downstream.receive(output);
  }

  @override
  void receiveSubscription(Subscription subscription) {
    _downstream.receiveSubscription(subscription);
  }

  @override
  void receiveError(Failure failure) {
    _downstream.receiveError(failure);
  }

  @override
  void receiveCompletion() {
    _downstream.receiveCompletion();
  }
}