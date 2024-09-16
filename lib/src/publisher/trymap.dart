
import 'package:dart_combine/dart_combine.dart';

extension PublisherTryMapExtension<Input, Failure extends Error, Upstream extends Publisher<Input, Failure>> on Publisher<Input, Failure> {
  Publisher<Output, Error> tryMap<Output>(Output Function(Input) transform) {
    return TryMap(
      upstream: this,
      transform: transform,
    );
  }
}

final class TryMap<Input, Output, Failure extends Error, Upstream extends Publisher<Input, Failure>> implements Publisher<Output, Error> {
  final Output Function(Input) _transform;
  final Upstream _upstream;

  const TryMap({
    required Upstream upstream,
    required Output Function(Input) transform,
  }) : _transform = transform,
        _upstream = upstream;

  @override
  void receive(Subscriber<Output, Error> subscriber) {
    final inner = _TryMapInner<Input, Output, Failure>(downstream: subscriber, transform: _transform);
    _upstream.receive(inner);
  }
}

final class _TryMapInner<Input, Output, Failure extends Error> implements Subscriber<Input, Failure> {
  final Subscriber<Output, Error> _downstream;
  final Output Function(Input) _transform;

  _TryMapInner({
    required Subscriber<Output, Error> downstream,
    required Output Function(Input) transform,
  }) : _downstream = downstream, 
       _transform = transform;

  @override
  void receive(Input input) {
    try {
      final output = _transform(input);
      _downstream.receive(output);
    } on Error catch (error) {
      _downstream.receiveError(error);
    }
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